// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");

let Hooks = {};
Hooks.StatsGraph = {
  mounted() {
    this.handleEvent("chart", ({ data }) => {
      console.log(data);

      const ctx = document.getElementById("myChart");
      const DATA_COUNT = 7;
      const NUMBER_CFG = { count: DATA_COUNT, min: -100, max: 100 };

      const labels = ["1", "2", "3", "4", "5", "6", "7"];
      const dumbData = {
        labels: labels,
        datasets: [
          {
            label: "Dataset 1",
            data: Chart.Utils.numbers(NUMBER_CFG),
            borderColor: Chart.Utils.CHART_COLORS.red,
            backgroundColor: Chart.Utils.transparentize(
              Chart.Utils.CHART_COLORS.red,
              0.5
            ),
            yAxisID: "y",
          },
          {
            label: "Dataset 2",
            data: Chart.Utils.numbers(NUMBER_CFG),
            borderColor: Chart.Utils.CHART_COLORS.blue,
            backgroundColor: Chart.Utils.transparentize(
              Chart.Utils.CHART_COLORS.blue,
              0.5
            ),
            yAxisID: "y1",
          },
        ],
      };
      const config = {
        type: "line",
        data: dumbData,
        options: {
          responsive: true,
          interaction: {
            mode: "index",
            intersect: false,
          },
          stacked: false,
          plugins: {
            title: {
              display: true,
              text: "Chart.js Line Chart - Multi Axis",
            },
          },
          scales: {
            y: {
              type: "linear",
              display: true,
              position: "left",
            },
            y1: {
              type: "linear",
              display: true,
              position: "right",

              // grid line settings
              grid: {
                drawOnChartArea: false, // only want the grid lines for one axis to show up
              },
            },
          },
        },
      };
      new Chart(ctx, config);
    });
  },
};

let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks: Hooks,
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
