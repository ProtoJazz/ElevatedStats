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
import { plugins } from "../tailwind.config";

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");

let Hooks = {};
Hooks.StatsGraph = {
  mounted() {
    this.handleEvent("chart", ({ data }) => {
      console.log(data);
      const plugin = {
        beforeInit(chart) {
          // Get a reference to the original fit function
          const originalFit = chart.legend.fit;

          // Override the fit function
          chart.legend.fit = function fit() {
            // Call the original function and bind scope in order to use `this` correctly inside it
            originalFit.bind(chart.legend)();
            // Change the height as suggested in other answers
            this.height += 1500;
          };
        },
      };
      const ctx = document.getElementById("myChart");
      const labels = data.lables;
      let images = data.icons.map((icon) => {
        var yourimage = new Image(40, 40);
        yourimage.src = icon;
        return yourimage;
      });
      console.log(images);

      const dumbData = {
        labels: labels,
        datasets: [
          {
            label: "Tower Damage",
            data: data.towerDamage,
            borderColor: "rgba(154,140,152, 1)",
            backgroundColor: "rgba(154,140,152, 0.5)",
            pointRadius: 50,
            pointHoverRadius: 20,
            pointHitRadius: 20,
            pointStyle: images,
            yAxisID: "y",
            lineTension: 0.4,
          },
          {
            label: "Damage Per Gold",
            data: data.damagePerGold,
            borderColor: "rgba(122,118,229, 1)",
            backgroundColor: "rgba(122,118,229, 0.5)",
            pointRadius: 10,
            pointHoverRadius: 1000,
            pointHitRadius: 20,
            pointStyle: images,
            yAxisID: "y1",
            lineTension: 0.4,
          },
        ],
      };
      const config = {
        type: "line",
        data: dumbData,
        options: {
          responsive: true,
          maintainAspectRatio: false,
          interaction: {
            mode: "index",
            intersect: false,
          },
          stacked: false,
          plugins: {
            title: {
              display: false,
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
