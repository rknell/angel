import 'package:angel_container/mirrors.dart';
import 'package:angel_framework/angel_framework.dart';

main() async {
  var app = new Angel(reflector: MirrorsReflector());

  // Index route. Returns JSON.
  app.get('/', () => 'Welcome to Angel!');

  // Accepts a URL like /greet/foo or /greet/bob.
  app.get('/greet/:name', (String name) => 'Hello, $name!');

  // Pattern matching - only call this handler if the query value of `name` equals 'emoji'.
  app.get('/greet', (@Query('name', match: 'emoji') String name) => '😇🔥🔥🔥');

  // Handle any other query value of `name`.
  app.get('/greet', (@Query('name') String name) => 'Hello, $name!');

  // Simple fallback to throw a 404 on unknown paths.
  app.use((RequestContext req) async {
    throw new AngelHttpException.notFound(
      message: 'Unknown path: "${req.uri.path}"',
    );
  });

  var http = new AngelHttp(app);
  var server = await http.startServer('127.0.0.1', 3000);
  var url = 'http://${server.address.address}:${server.port}';
  print('Listening at $url');
  print('Visit these pages to see Angel in action:');
  print('* $url/greet/bob');
  print('* $url/greet/?name=emoji');
  print('* $url/greet/?name=jack');
  print('* $url/nonexistent_page');
}
