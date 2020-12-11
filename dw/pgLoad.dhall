λ(sqliteFilepath : Text) →
λ(pgTarget : Text) →
  ''
  LOAD database
  FROM '${sqliteFilepath}'
  INTO ${pgTarget}

  WITH data only

  AFTER LOAD DO
    $$ BEGIN TRANSACTION; $$,
      $$ CREATE TEMP TABLE events_deduped AS SELECT DISTINCT * FROM events; $$,
      $$ TRUNCATE TABLE events; $$,
      $$ INSERT INTO events SELECT * FROM events_deduped; $$,
      $$ DROP TABLE events_deduped; $$,
    $$ COMMIT; $$
  ;
  ''
