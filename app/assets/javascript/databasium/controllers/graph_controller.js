import { Controller } from "@hotwired/stimulus";
import { Graph, InternalEvent, HierarchicalLayout } from "@maxgraph/core";
import "databasium/shapes/erd_table_shape";

// Connects to data-controller="graph"
export default class extends Controller {
  static values = { tables: String };

  connect() {
    const data = JSON.parse(this.tablesValue);

    const container = this.element;
    InternalEvent.disableContextMenu(container);
    const graph = new Graph(container);
    graph.setPanning(true);

    const panningHandler = graph.getPlugin("PanningHandler");
    if (panningHandler) {
      panningHandler.useLeftButtonForPanning = true;
    }
    container.style.cursor = "grab";

    container.addEventListener(
      "wheel",
      (event) => {
        event.preventDefault();

        const currentScale = graph.view.scale;
        const zoomFactor = event.deltaY < 0 ? 1.06 : 0.94;
        const nextScale = Math.min(Math.max(currentScale * zoomFactor, 0.25), 2.5);

        graph.zoomTo(nextScale, true);
      },
      { passive: false }
    );

    graph.getStylesheet().getDefaultEdgeStyle().edgeStyle = "orthogonalEdgeStyle";

    const vertexes = this.addVertexes(graph, data);
    const edges = this.addEdges(graph, data, vertexes);

    const layout = new HierarchicalLayout(graph);
    layout.execute(graph.getDefaultParent());
  }

  addLabelToEdge(graph, edge, text, position = "start") {
    const x = position === "start" ? -0.85 : 0.85;

    graph.insertVertex(
      edge,
      null,
      text,
      x,
      0,
      1,
      1,
      {
        fillColor: "none",
        strokeColor: "none",
        fontColor: "var(--color-main-text)",
        fontSize: 12,
        align: "center",
        verticalAlign: "middle",
        labelBackgroundColor: "var(--color-panel)",
        labelPadding: 4
      },
      true // relative — without this, labels won't appear on the edge
    );
  }

  addEdges(graph, data, vertexes) {
    const edgeStyle = {
      edgeStyle: "orthogonalEdgeStyle",
      rounded: true,
      startArrow: "none",
      endArrow: "none",
      strokeColor: "var(--color-border)",
      strokeWidth: 2
    };

    graph.batchUpdate(() => {
      const alreadySet = new Set();
      for (let table of Object.keys(data)) {
        for (let association of data[table]?.associations || []) {
          const relatedTable = data[association.name];
          if (!relatedTable || !vertexes[association.name]) continue;
          if (alreadySet.has(`${association.name}-${table}`)) continue;

          alreadySet.add(`${table}-${association.name}`);

          const sourceMacro = association.macro;
          const targetMacro = relatedTable.associations?.find(
            (assoc) => assoc.name === table
          )?.macro;

          const edge = graph.insertEdge({
            source: vertexes[table],
            target: vertexes[association.name],
            style: edgeStyle
          });
          // macros are declered on oposite sites, thats why we use labels for oposite macros
          this.addLabelToEdge(
            graph,
            edge,
            `${this.getLabelForEdge(sourceMacro)} (${targetMacro ?? "Missing relation"})`,
            "end"
          );
          this.addLabelToEdge(
            graph,
            edge,
            `${this.getLabelForEdge(targetMacro)} (${sourceMacro ?? "Missing relation"})`,
            "start"
          );
        }
      }
    });
  }

  getLabelForEdge(macro) {
    switch (macro) {
      case "has_many":
        return "0..*";
      case "has_one":
        return "1";
      case "belongs_to":
        return "1";
      case "has_and_belongs_to_many":
        return "0..*";
      default:
        return "0..*";
    }
  }

  addZooming(graph) {
    this.element.addEventListener(
      "wheel",
      (event) => {
        event.preventDefault();

        const currentScale = graph.view.scale;
        const zoomFactor = event.deltaY < 0 ? 1.06 : 0.94;
        const nextScale = Math.min(Math.max(currentScale * zoomFactor, 0.25), 2.5);

        graph.zoomTo(nextScale, true);
      },
      { passive: false }
    );
  }

  addVertexes(graph, data) {
    const vertexes = {};
    const parent = graph.getDefaultParent();

    graph.batchUpdate(() => {
      for (let table of Object.keys(data)) {
        let longest = this.detectedMaxLength(data[table], "name");
        let longestValue = this.detectedMaxLength(data[table], "sql_type");
        let width = (longest + longestValue + 4) * 8;
        const vertex = graph.insertVertex(
          parent,
          null,
          {
            name: table,
            fields: this.getFields(data[table].columns)
          },
          0,
          0,
          width,
          data[table].columns.filter((column) => column != undefined).length * 32 + 32,
          { shape: "erdTable", label: "", fontSize: 0, perimeter: "rectanglePerimeter" }
        );
        vertexes[table] = vertex;
      }
    });
    return vertexes;
  }

  getFields(columns) {
    return columns
      .filter((column) => column != undefined)
      .map((column) => {
        return { name: column.name, sql_type: column.sql_type };
      });
  }

  detectedMaxLength(table, type) {
    return (
      table.columns.reduce((max, column) => {
        return Math.max(max, column[type].length);
      }, 0) || 0
    );
  }
}
