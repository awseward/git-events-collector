λ(sqliteFilepath : Text) →
λ(pgTarget : Text) →
  ''
  LOAD database
  FROM '${sqliteFilepath}'
  INTO ${pgTarget}

  WITH data only

  -- This might be better to be owned by a different process?
  BEFORE LOAD DO
    $$
      CREATE TABLE IF NOT EXISTS events (
        version   TEXT                     NOT NULL,
        timestamp TIMESTAMP WITH TIME ZONE NOT NULL,
        hook      TEXT                     NOT NULL,
        repo      TEXT                     NOT NULL,
        ref       TEXT                     NOT NULL
      );
    $$

  AFTER LOAD DO
    $$ BEGIN TRANSACTION; $$,
      $$ CREATE TEMP TABLE events_deduped AS SELECT DISTINCT * FROM events; $$,
      $$ TRUNCATE TABLE events; $$,
      $$ INSERT INTO events SELECT * FROM events_deduped; $$,
      $$ DROP TABLE events_deduped; $$,
    $$ COMMIT; $$
  ;
  ''
