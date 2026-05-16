import { Shape, ShapeRegistry } from "@maxgraph/core";

export default class ErdTableShape extends Shape {
  paintVertexShape(c, x, y, w, h) {
    const { name, fields } = this.state.cell.value;
    const headerHeight = 32;

    c.setFillColor("var(--color-panel)");
    c.setStrokeColor("var(--color-border)");
    c.setStrokeWidth(2);
    c.rect(x, y, w, fields.length * 32 + headerHeight);
    c.fillAndStroke();

    c.setFillColor("var(--color-panel)");
    c.rect(x, y, w, headerHeight);
    c.fillAndStroke();

    c.setFontStyle(1);
    c.setFontSize(16);
    c.setFontColor("var(--color-main-text)");
    c.text(x + 4, y + 4, 0, 0, name, "left", "top", false, false);

    c.setFontStyle(0);
    c.setFontSize(16);

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
