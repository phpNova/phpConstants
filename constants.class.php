<?php

class Constants
{
	public function __construct()
	{
		$args = func_get_args();
		
		foreach ( $args as $argarr )
		{
			foreach ( $argarr as $key => $value )
			{
				$this->$key = $value;
			}
		}
		
		if ( !isset( $this->config ) )
		{
			require_once( "config.parent.php" );
			
			$this->config = new Config( FALSE );
			$this->config->setup_db();
		}
		
		$this->initialize();
	}
	
	/* Load all constants or just a group of constants.  --Kris */
	public function load_constants( $title = NULL )
	{
		if ( defined( "PHPNOVA_CONSTANTS_DEFINED_ALL" ) 
			&& constant( "PHPNOVA_CONSTANTS_DEFINED_ALL" ) == TRUE )
		{
			return;
		}
		
		/* If NULL, load all the titles.  Any constant without a corresponding title is ignored.  --Kris */
		if ( $title == NULL )
		{
			$res = $this->config->sql->query( "select title, prefix from constant_types" );
		}
		else
		{
			$res = $this->config->sql->query( "select title, prefix from constant_types where title = ?", array( $title ) );
		}
		
		foreach ( $res as $result )
		{
			if ( defined( 'PHPNOVA_CONSTANT_TYPE_DEFINED_' . strtoupper( $result["title"] ) ) 
				&& constant( 'PHPNOVA_CONSTANT_TYPE_DEFINED_' . strtoupper( $result["title"] ) ) == TRUE )
			{
				continue;
			}
			
			$clause = $this->config->sql->build_where_clause( "title", $result["title"] );
			
			$query = "select * from constants" . ( $clause !== FALSE ? " where " . $clause[0] : NULL );
			
			$constants = $this->config->sql->query( $query, $clause[1] );
			
			foreach ( $constants as $constant )
			{
				/* The PHPNOVA_ prefix is reserved for the framework.  --Kris */
				if ( strlen( $result["prefix"] . $constant["constant"] ) < 8 
						|| strcasecmp( substr( $result["prefix"] . $constant["constant"], 0, 8 ), "PHPNOVA_" ) )
				{
					$this->define( $result["prefix"] . $constant["constant"], $constant["value"] );
				}
			}
			
			/* Special constant to reduce DB load by not having to check database for constants that have already been defined.  --Kris */
			$this->define( 'PHPNOVA_CONSTANT_TYPE_DEFINED_' . strtoupper( $result["title"] ), TRUE );
		}
		
		/* If ALL constants have been defined, we can save even more time.  --Kris */
		if ( $title == NULL )
		{
			$this->define( 'PHPNOVA_CONSTANTS_DEFINED_ALL', TRUE );
		}
	}
	
	/* Defines a constant.  Handles sanity checking to avoid PHP errors.  Case-insensitivity is NOT recommended!  Constants should be all uppercase.  --Kris */
	public function define( $var, $val, $case_insensitive = FALSE )
	{
		return ( defined( $var ) ? FALSE : define( $var, $val, $case_insensitive ) );
	}
	
	/* Assign incremental bit values to any types awaiting initializion.  Intended as a convenience.  Use with caution!  --Kris */
	// Should only be used to build the BASE LEVELS!  Any combination bit entries (i.e. value1 + value2) must be added manually later.  --Kris
	private function initialize( $unique = TRUE )
	{
		/* Load the "ALL" values for already-initialized constants.  --Kris */
		$query = "select title, prefix from constant_types where initialized <> ?";
		
		$res = $this->config->sql->query( $query, array( 0 ) );
		
		foreach ( $res as $title )
		{
			/* If no corder is specified, value will be skipped.  Useful for combos and other manual values.  --Kris */
			$query = "select constant from constants where title = ? AND ( value = '' OR value IS NULL ) AND corder <> '' ORDER BY corder ASC";
			$res2 = $this->config->sql->query( $query, array( $title["title"] ) );
			
			if ( $unique == TRUE )
			{
				$i = 0x02;
			}
			else
			{
				$i = 0x01;
			}
			
			$sum = 0x00;
			foreach ( $res2 as $constant )
			{
				$sum += $i;
				
				$i *= 2;
			}
			
			$this->init_all( $title["title"], $title["prefix"], $sum );
		}
		
		/* Now initialize the ones that need it.  --Kris */
		$query = "select title, prefix from constant_types where initialized = ?";
		
		$res = $this->config->sql->query( $query, array( 0 ) );
		
		foreach ( $res as $title )
		{
			/* If no corder is specified, value will be left as-is.  Useful for combos and other manual values.  --Kris */
			$query = "select constant from constants where title = ? AND ( value = '' OR value IS NULL ) AND corder <> '' ORDER BY corder ASC";
			$res2 = $this->config->sql->query( $query, array( $title["title"] ) );
			
			if ( $unique == TRUE )
			{
				$i = 0x02;
			}
			else
			{
				$i = 0x01;
			}
			
			$sum = 0x00;
			foreach ( $res2 as $constant )
			{
				$sum += $i;
				
				$query = "update constants set type = ?, value = ? where constant = ?";
				$this->config->sql->query( $query, array( "hex", "$i", $constant["constant"] ), SQL_RETURN_AFFECTEDROWS );
				
				$i *= 2;
			}
			
			$this->init_all( $title["title"], $title["prefix"], $sum );
		}
		
		/* Now we set these as initialized so that this won't happen on every script execution.  Set back to 0 manually to re-initialize.  --Kris */
		$query = "update constant_types set initialized = ? where initialized = ?";
		$res = $this->config->sql->query( $query, array( 1, 0 ), SQL_RETURN_AFFECTEDROWS );
	}
	
	/* Create a $prefix . "ALL" constant that is the sum of all other values of the same type.  --Kris */
	private function init_all( $title, $prefix, $sum = NULL )
	{
		/* If an "all" value already exists, delete it then re-create.  --Kris */
		$res = $this->config->sql->query( "delete from constants where title = ? AND constant like('%\\_ALL')", array( $title ), SQL_RETURN_AFFECTEDROWS );
		
		if ( $sum == NULL )
		{
			/* Get the total sum.  Currently does NOT account for string values (not sure how MySQL casts them).  --Kris */
			$query = "select SUM(value) as valsum from constants where title = ? AND value <> '' AND value > 0";
			$res = $this->config->sql->query( $query, array( $title ) );
			
			$sum = dechex( $res[0]["valsum"] );
		}
		
		/* Insert into the database.  --Kris */
		$query = "insert into constants ( constant, title, type, value ) VALUES ( ?, ?, ?, ? )";
		$inserts = array( $prefix . "ALL", $title, "hex", $sum );
		
		$this->config->sql->query( $query, $inserts, SQL_RETURN_AFFECTEDROWS );
		
		$this->define( $prefix . "ALL", $sum );
	}
}
