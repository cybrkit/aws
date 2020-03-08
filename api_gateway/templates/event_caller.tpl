'use strict';

const JSON_STRINGIFY_INDENT = 2;
const e = React.createElement;

class EventCaller extends React.Component {
  constructor(props) {
    super(props);
    this.state = { eventBody: '' };
  }

  componentDidMount() {
    this.GetEvent();
  }

  GetEvent() {
      fetch(this.props.endpoint)
      .then(response => {
        return response.json();
      })
      .then(responseBody => {
          this.setState({ eventBody: JSON.stringify(responseBody, null, JSON_STRINGIFY_INDENT)});
      });
  }


  render() {
    let eventBody = this.state.eventBody;
    return (
      <div id="event-body-text">
        <h2>Event Body Should Be Here</h2>
        <pre>
          { eventBody }
        </pre>
      </div>
    );
  }
}