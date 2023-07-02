import 'package:postgres/postgres.dart';

Future open_connection(connection) async {
  connection = PostgreSQLConnection(
    "10.0.2.2",
     5432,
      "study_english",
       username: "postgres",
        password: "postgres",
        // timeoutInSeconds: 30,
        // queryTimeoutInSeconds: 30,
        // timeZone: 'UTC',
        // isUnixSocket: false,
        // allowClearTextPassword: false,
        // replicationMode: ReplicationMode.none
        );
  await connection.open();
} 