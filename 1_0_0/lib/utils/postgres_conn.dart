import 'package:postgres/postgres.dart';

class Connect {
  
static var connection;

static Future open_connection() async {
  connection = PostgreSQLConnection(
    "10.0.2.2",
     5432,
      "postgres",
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
}
