var create_visualization = function() {
  var dataset;
  var transcript_id = getUrlParameter('transcript');

  var plot_data = function(data) {
    // Change these to fine-tune graph
    var margin = { top: 20, right: 10, bottom: 20, left: 10 };
    var width = 960 - margin.left - margin.right;
    var lanes_count = 2;
    var lane_height = 150;
    var lane_vertical_margin = 20;
    var domain_padding = 1000;
    var scale_to_changes = false;
    //////////////////////////////////

    var height = lanes_count * (lane_height + 2 * lane_vertical_margin);
    var exon_height = Math.round(lane_height * 0.75);
    var utr_height = Math.round(exon_height * 0.5);
    var change_height = utr_height;

    var extract_domain = function(data) {
      var start = data.utr5.start;
      var stop = data.utr3.stop;

      var min_change = d3.min(data.changes, function(d) {
        return d.start;
      });

      var max_change = d3.max(data.changes, function(d) {
        return d.stop;
      });

      if (scale_to_changes) {
        start = d3.min([start, min_change]);
        stop = d3.max([stop, max_change]);
      }

      return [start - domain_padding, stop + domain_padding];
    }

    var lane_y_position = function(lane_index) {
      var lane_box_height = lane_height + 2 * lane_vertical_margin;
      var y = 0;

      for (var i = 0 ; i < lane_index ; i++) {
        y += lane_box_height;
      }

      return y + lane_box_height / 2;
    }

    var x_scale = d3.scaleLinear()
        .domain(extract_domain(data))
        .range([0, width]);

    var svg = d3.select("#variants-visualization").append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
      .append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    var plot_graph_element = function(element, lane_y, element_height, element_class) {
      var x1 = x_scale(element.start);
      var x2 = x_scale(element.stop);

      var scaled_width = x2 - x1;

      svg.append("rect")
          .attr("class", element_class)
          .attr("x", x1)
          .attr("y", lane_y - element_height / 2)
          .attr("width", scaled_width)
          .attr("height", element_height);
    }

    // Plot axes
    for (var i = 0 ; i < lanes_count ; i++) {
      var y = lane_y_position(i);
      svg.append("line")
          .attr("x1", 0)
          .attr("y1", y)
          .attr("x2", width)
          .attr("y2", y);
    }

    // Plot exons
    var exon_lane_y = lane_y_position(0);

    for (var i = 0 ; i < data.exons.length ; i++) {
      var exon = data.exons[i];
      plot_graph_element(exon, exon_lane_y, exon_height, "exon");
    }

    // Plot utrs
    plot_graph_element(data.utr5, exon_lane_y, utr_height, "utr");
    plot_graph_element(data.utr3, exon_lane_y, utr_height, "utr");

    // Plot changes
    var changes_lane_y = lane_y_position(1);

    for (var i = 0 ; i < data.changes.length ; i++) {
      var change = data.changes[i];
      plot_graph_element(change, changes_lane_y, change_height, change.type);
    }
  }

  var load_data = function(transcript_id) {
    d3.json("/api/variants?transcript=" + transcript_id, function(data) {
      plot_data(data);
    });
  }

  if (transcript_id && transcript_id.length > 0)  {
    load_data(transcript_id);
  }
}

create_visualization();
