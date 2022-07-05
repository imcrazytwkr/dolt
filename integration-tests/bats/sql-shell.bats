#!/usr/bin/env bats
load $BATS_TEST_DIRNAME/helper/common.bash

setup() {
    setup_common
    dolt sql <<SQL
CREATE TABLE test (
  pk BIGINT NOT NULL COMMENT 'tag:0',
  c1 BIGINT COMMENT 'tag:1',
  c2 BIGINT COMMENT 'tag:2',
  c3 BIGINT COMMENT 'tag:3',
  c4 BIGINT COMMENT 'tag:4',
  c5 BIGINT COMMENT 'tag:5',
  PRIMARY KEY (pk)
);
SQL
}

teardown() {
    assert_feature_version
    teardown_common
}

@test "sql-shell: run a query in sql shell" {
    skiponwindows "Works on Windows command prompt but not the WSL terminal used during bats"
    run bash -c "echo 'select * from test;' | dolt sql"
    [ $status -eq 0 ]
    [[ "$output" =~ "pk" ]] || false
}

@test "sql-shell: sql shell writes to disk after every iteration (autocommit)" {
    skiponwindows "Need to install expect and make this script work on windows."
    run $BATS_TEST_DIRNAME/sql-shell.expect
    echo "$output"

    # 2 tables are created. 1 from above and 1 in the expect file.
    [[ "$output" =~ "+---------------------" ]] || false
    [[ "$output" =~ "| Tables_in_dolt_repo_" ]] || false
    [[ "$output" =~ "+---------------------" ]] || false
    [[ "$output" =~ "| test                " ]] || false
    [[ "$output" =~ "| test_expect         " ]] || false
    [[ "$output" =~ "+---------------------" ]] || false
}

@test "sql-shell: dolt sql shell with default doltcfg directory" {
    # remove existing .doltcfg
    rm -rf .doltcfg

    # show users, expect just root user
    run dolt sql <<< "select user from mysql.user;"
    [[ "$output" =~ "root" ]] || false
    ! [[ "$output" =~ "new_user" ]] || false

    # check that .doltcfg exists
    run ls -a
    [[ "$output" =~ ".doltcfg" ]] || false

    # check that ./doltcfg/privileges.db does not exist
    run ls .doltcfg
    ! [[ "$output" =~ "privileges.db" ]] || false

    # create a new user
    run dolt sql <<< "create user new_user;"
    [ "$status" -eq 0 ]

    # show users, expect root user and new_user
    run dolt sql <<< "select user from mysql.user;"
    [[ "$output" =~ "root" ]] || false
    [[ "$output" =~ "new_user" ]] || false

    # check that .doltcfg exists
    run ls -a
    [[ "$output" =~ ".doltcfg" ]] || false

    # check that ./doltcfg/privileges.db exists
    run ls .doltcfg
    [[ "$output" =~ "privileges.db" ]] || false

    # remove mysql.db just in case
    rm -f .dolt/mysql.db
}

@test "sql-shell: dolt sql shell specify doltcfg directory" {
    # remove existing .doltcfg
    rm -rf .doltcfg

    # show users, expect just root user
    run dolt sql --doltcfg-dir=thisisthedoltcfgdir <<< "select user from mysql.user;"
    [[ "$output" =~ "root" ]] || false
    ! [[ "$output" =~ "new_user" ]] || false

    # check that .doltcfg does not exist
    run ls -a
    ! [[ "$output" =~ ".doltcfg" ]] || false

    # check that custom doltcfg dir exists
    run ls -a
    [[ "$output" =~ "thisisthedoltcfgdir" ]] || false

    # create a new user
    run dolt sql --doltcfg-dir=thisisthedoltcfgdir <<< "create user new_user;"
    [ "$status" -eq 0 ]

    # show users, expect root user and new_user
    run dolt sql --doltcfg-dir=thisisthedoltcfgdir <<< "select user from mysql.user;"
    [[ "$output" =~ "root" ]] || false
    [[ "$output" =~ "new_user" ]] || false

    # check that ./thisisthedoltcfgdir/privileges.db exists
    run ls thisisthedoltcfgdir
    [[ "$output" =~ "privileges.db" ]] || false

    # remove config files
    rm -rf .doltcfg
    rm -rf thisisthedoltcfgdir
}

@test "sql-shell: dolt sql shell specify privilege file" {
    # remove existing files
    rm -rf .doltcfg
    rm -rf privileges.db

    # show users, expect just root user
    run dolt sql --privilege-file=privileges.db <<< "select user from mysql.user;"
    [[ "$output" =~ "root" ]] || false
    ! [[ "$output" =~ "new_user" ]] || false

    # check that .doltcfg does not exist
    run ls -a
    [[ "$output" =~ ".doltcfg" ]] || false

    # create a new user
    run dolt sql --privilege-file=privileges.db <<< "create user new_user;"
    [ "$status" -eq 0 ]

    # show users, expect root user and new_user
    run dolt sql --privilege-file=privileges.db <<< "select user from mysql.user;"
    [[ "$output" =~ "root" ]] || false
    [[ "$output" =~ "new_user" ]] || false

    # check that privileges.db exists
    run ls
    [[ "$output" =~ "privileges.db" ]] || false

    # remove mysql.db just in case
    rm -rf .doltcfg
    rm -rf privileges.db
}

@test "sql-shell: bad sql in sql shell should error" {
    run dolt sql <<< "This is bad sql"
    [ $status -eq 1 ]
    run dolt sql <<< "select * from test; This is bad sql; insert into test (pk) values (666); select * from test;"
    [ $status -eq 1 ]
    [[ ! "$output" =~ "666" ]] || false
}

@test "sql-shell: inline query with missing -q flag should error" {
    run dolt sql "SELECT * FROM test;"
    [ $status -eq 1 ]
    [[ "$output" =~ "Invalid Argument:" ]] || false
}

@test "sql-shell: validate string formatting" {
      dolt sql <<SQL
CREATE TABLE test2 (
  str varchar(256) NOT NULL,
  PRIMARY KEY (str)
);
SQL
  dolt add .
  dolt commit -m "created table"

  TESTSTR='0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ`~!@#$%^&*()){}[]/=?+|,.<>;:_-_%d%s%f'
  dolt sql -q "INSERT INTO test2 (str) VALUES ('$TESTSTR')"

  run dolt sql -q "SELECT * FROM test2"
  [ $status -eq 0 ]
  [[ "$output" =~ "$TESTSTR" ]] || false

  run dolt sql -q "SELECT * FROM test2" -r csv
  [ $status -eq 0 ]
  [[ "$output" =~ "$TESTSTR" ]] || false

  run dolt sql -q "SELECT * FROM test2" -r json
  [ $status -eq 0 ]
  [[ "$output" =~ "$TESTSTR" ]] || false

  dolt add .
  dolt commit -m "added data"

  run dolt diff HEAD^
  [ $status -eq 0 ]
  echo $output
  [[ "$output" =~ "$TESTSTR" ]] || false
}

@test "sql-shell: active branch after checkout" {
    run dolt sql <<< "select active_branch()"
    [ $status -eq 0 ]
    [[ "$output" =~ "active_branch()" ]] || false
    [[ "$output" =~ "main" ]] || false
    run dolt sql <<< "select dolt_checkout('-b', 'tmp_br') as co; select active_branch()"
    [ $status -eq 0 ]
    [[ "$output" =~ "active_branch()" ]] || false
    [[ "$output" =~ "tmp_br" ]] || false
}
