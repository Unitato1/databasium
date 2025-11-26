import { Controller } from "@hotwired/stimulus"
import { Graph, InternalEvent } from "@maxgraph/core"

export default class extends Controller {
	connect() {
		const container = this.element
		InternalEvent.disableContextMenu(container)

		const graph = new Graph(container)
		graph.setPanning(true)

		graph.batchUpdate(() => {
			const vertex01 = graph.insertVertex({
				position: [10, 10],
				size: [100, 100],
				value: "rectangle"
			})

			const vertex02 = graph.insertVertex({
				position: [350, 90],
				size: [50, 50],
				style: {
					fillColor: "orange",
					shape: "ellipse",
					verticalAlign: "top",
					verticalLabelPosition: "bottom"
				},
				value: "ellipse"
			})

			graph.insertEdge({
				source: vertex01,
				target: vertex02,
				value: "edge",
				style: {
					edgeStyle: "orthogonalEdgeStyle",
					rounded: true
				}
			})
		})
	}
}


