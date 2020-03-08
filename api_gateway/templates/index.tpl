<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>AWS Sample</title>
  </head>
  <body>

    <h2>Hello World</h2>
    <p>This page embeds a callback which is checked by AWS.</p>

    <input
      type="url"
      name="endpoint_url"
      id="endpoint_url"
      size="120"
      disabled="true"
      value="${callback_url}"
    />
    <div id="root"></div>

    <!-- Load React. -->
    <!-- Note: when deploying, replace "development.js" with "production.min.js". -->
    <script src="https://unpkg.com/react@^16/umd/react.development.js" crossorigin></script>
    <script src="https://unpkg.com/react-dom@^16/umd/react-dom.development.js" crossorigin></script>
    <script src="https://unpkg.com/babel-standalone@6/babel.min.js"></script>

    <!-- Load our React component. -->
    <script type="text/babel" src="event_caller.js"></script>
    <script type="text/babel">
    ReactDOM.render(
      <EventCaller endpoint={endpoint_url.value}/>,
      document.getElementById('root'));
    </script>
  </body>
</html>
