import { Controller } from "@hotwired/stimulus"
import { Graph, InternalEvent, HierarchicalLayout, CompactTreeLayout } from "@maxgraph/core"

// Connects to data-controller="graph"
export default class extends Controller {

  static values = { tables: Array }

  connect() {
    console.log(this.tablesValue)
    const container = this.element
    InternalEvent.disableContextMenu(container)

    const graph = new Graph(container)
    graph.setPanning(true)

    graph.batchUpdate(() => {
      const vertexes = []
      let i = 1;
      for (let table of this.tablesValue) {
      
        const vertex = graph.insertVertex({
          position: [120 * i, 10],
          size: [100, 100],
          value: table
        })
        i++;
        // if (vertexes.length > 0) {
        //   graph.insertEdge({
        //     source: vertexes[vertexes.length - 1],
        //     target: vertex,
        //     value: "edge",
        //     style: {
        //         edgeStyle: "orthogonalEdgeStyle",
        //         rounded: true
        //     }
        //   })          
        // }
        // vertexes.push(vertex)
      }

    // const layout = new HierarchicalLayout(graph)           // layered layout
    const layout = new CompactTreeLayout(graph, false)   // tree layout (toggle orientation with 2nd arg)
// Run on all cells under the default parent, or pass `vertexes` to limit scope
    layout.execute(graph.getDefaultParent(), vertexes)
    })
  }
}
