//// Import theses libraries.
//import 'package:logging/logging.dart';
//import 'package:signalr_client/signalr_client.dart';
//import 'package:signalr_core/signalr_core.dart';
//
//Logging Logger = Logging();
//// Configer the logging
//Logger.root.level = Level.ALL;
//// Writes the log messages to the console
//Logger.root.onRecord.listen((LogRecord rec) {
//print('${rec.level.name}: ${rec.time}: ${rec.message}');
//});
//
//// If you want only to log out the message for the higer level hub protocol:
//final hubProtLogger = Logger("SignalR - hub");
//// If youn want to also to log out transport messages:
//final transportProtLogger = Logger("SignalR - transport");
//
//// The location of the SignalR Server.
//final serverUrl = "192.168.10.50:51001";
//final connectionOptions = HttpConnectionOptions;
//final httpOptions = new HttpConnectionOptions(logger: transportProtLogger);
////final httpOptions = new HttpConnectionOptions(logger: transportProtLogger, transport: HttpTransportType.WebSockets); // default transport type.
////final httpOptions = new HttpConnectionOptions(logger: transportProtLogger, transport: HttpTransportType.ServerSentEvents);
////final httpOptions = new HttpConnectionOptions(logger: transportProtLogger, transport: HttpTransportType.LongPolling);
//
//// If you need to authorize the Hub connection than provide a an async callback function that returns
//// the token string (see AccessTokenFactory typdef) and assigned it to the accessTokenFactory parameter:
//// final httpOptions = new HttpConnectionOptions( .... accessTokenFactory: () async => await getAccessToken() );
//
//// Creates the connection by using the HubConnectionBuilder.
//final hubConnection = HubConnectionBuilder().withUrl(serverUrl, options: httpOptions).configureLogging(hubProtLogger).build();
//// When the connection is closed, print out a message to the console.
//final hubConnection.onclose( (error) => print("Connection Closed"));

