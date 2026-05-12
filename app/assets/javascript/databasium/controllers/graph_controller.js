import { Controller } from "@hotwired/stimulus";
import {
  Graph,
  InternalEvent,
  HierarchicalLayout,
  CompactTreeLayout,
  ShapeRegistry,
  Shape,
  FastOrganicLayout,
  CoordinateAssignment,
  SwimlaneOrdering
} from "@maxgraph/core";

class ErdTableShape extends Shape {
  paintVertexShape(c, x, y, w, h) {
    const { name, fields } = this.state.cell.value;
    const headerHeight = 32;

    c.setFillColor("var(--color-panel)");
    c.setStrokeColor("var(--color-border)");
    c.setStrokeWidth(2);
    c.rect(x, y, w, fields.length * 32 + headerHeight);
    c.fillAndStroke();

    // Header background
    c.setFillColor("var(--color-panel)");
    c.rect(x, y, w, headerHeight);
    c.fillAndStroke();

    // Header text
    c.setFontStyle(1);
    c.setFontSize(16);
    c.setFontColor("var(--color-main-text)");
    c.text(x + 4, y + 4, 0, 0, name, "left", "top", false, false);

    // Reset font style
    c.setFontStyle(0);
    c.setFontSize(16);

    // Draw rows
    let rowY = y + headerHeight;
    const rowHeight = 32;
    fields?.forEach((field) => {
      c.setStrokeWidth(1);
      c.setStrokeColor("var(--color-border)");
      c.stroke();
      c.begin();
      c.moveTo(x, rowY);
      c.lineTo(x + w, rowY);
      c.stroke();
      // Text
      c.setFontColor("var(--color-main-text)");
      c.text(
        x + 6,
        rowY + 4,
        0,
        0,
        `${field.name} ${" - " + field.sql_type}`,
        "left",
        "top",
        false,
        false
      );

      rowY += rowHeight;
    });
  }
}

ShapeRegistry.add("erdTable", ErdTableShape);

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

    const parent = graph.getDefaultParent();
    graph.getStylesheet().getDefaultEdgeStyle().edgeStyle = "orthogonalEdgeStyle";

    const vertexes = [];
    graph.batchUpdate(() => {
      for (let table of Object.keys(data)) {
        const vertex = graph.insertVertex(
          parent,
          null,
          {
            name: table,
            fields: data[table].columns
              .filter((column) => column != undefined)
              .map((column) => {
                return { name: column.name, sql_type: column.sql_type };
              })
          },
          0,
          0,
          300,
          data[table].columns.filter((column) => column != undefined).length * 32 + 32,
          { shape: "erdTable", label: "", fontSize: 0, perimeter: "rectanglePerimeter" }
        );
        vertexes.push(vertex);
      }
    });

    graph.batchUpdate(() => {
      for (let table of Object.keys(data)) {
        for (let association of data[table].associations) {
          graph.insertEdge({
            source: vertexes.find((vertex) => vertex.value.name === table),
            target: vertexes.find((vertex) => vertex.value.name === association.name),
            value: association.macro,
            style: {
              edgeStyle: "manhattanEdgeStyle"
            }
          });
        }
      }
    });

    const layout = new HierarchicalLayout(graph); // layered layout
    // const layout = new CompactTreeLayout(graph, false)   // tree layout (toggle orientation with 2nd arg)
    // Run on all cells under the default parent, or pass `vertexes` to limit scope
    layout.execute(parent);
    // })
  }
}
