var create_visualization = function() {
  var dataset;
  var transcript_id = getUrlParameter('transcript');

  var plot_data = function(data) {
    // Change these to fine-tune graph
    var margin = { top: 20, right: 10, bottom: 20, left: 10 };
    var width = 960.0 - margin.left - margin.right;
    var lane_height = 150;
    var lane_vertical_margin = 20;
    var domain_padding = 1000;
    var exon_on_screen_percentage = 0.8;
    var minimum_width = 2;
    //////////////////////////////////

    var calculate_height = function(lanes_count) {
      return lanes_count * (lane_height + 2 * lane_vertical_margin);
    }

    var VariantsApp = {};
    VariantsApp.lanes_count = 2;

    var height = calculate_height(VariantsApp.lanes_count);
    var exon_height = Math.round(lane_height * 0.75);
    var exon_in_utr_height = Math.round(exon_height * 0.5);
    var utr_height = Math.round(exon_height * 0.3);
    var change_height = utr_height;


    var extract_domain = function(data) {
      var start = data.utr5.start;
      var stop = data.utr3.stop;

      VariantsApp.utr5 = [data.utr5.start, data.utr5.stop];
      VariantsApp.utr3 = [data.utr3.start, data.utr3.stop];

      return [start - domain_padding, stop + domain_padding];
    }

    var domain = extract_domain(data);

    VariantsApp.scale_start = domain[0];
    VariantsApp.scale_stop = domain[1];
    VariantsApp.exon_regions = [];
    VariantsApp.change_lanes = [[]];

    var calculate_scale_factors = function(data) {
      var scale_size = VariantsApp.scale_stop - VariantsApp.scale_start;

      var exon_sizes_sum = 0.0;

      // adding up exon sizes
      for (var i = 0 ; i < data.exons.length ; i++) {
        var exon = data.exons[i];
        exon_sizes_sum += exon.stop - exon.start;
        VariantsApp.exon_regions.push([exon.start, exon.stop])
      }

      VariantsApp.exon_scale_factor = width * exon_on_screen_percentage / exon_sizes_sum;
      VariantsApp.intron_scale_factor = width * (1 - exon_on_screen_percentage) / (scale_size - exon_sizes_sum);
    }

    calculate_scale_factors(data);

    var x_scale = function(x) {
      var start = VariantsApp.scale_start;
      var passed_exons_size = 0;

      for (var i = 0 ; i < VariantsApp.exon_regions.length ; i++) {
        var exon = VariantsApp.exon_regions[i];
        var exon_start = exon[0];
        var exon_stop = exon[1];

        if (x >= exon_stop) {
          // after whole exon
          passed_exons_size += exon_stop - exon_start;
        } else if (x <= exon_start) {
          // before whole exon
          break;
        } else {
          // inside exon
          passed_exons_size += x - exon_start;
          break;
        }
      }

      var passed_introns_size = x - start - passed_exons_size;
      return passed_exons_size * VariantsApp.exon_scale_factor + passed_introns_size * VariantsApp.intron_scale_factor;
    }

    var lane_y_position = function(lane_index) {
      var lane_box_height = lane_height + 2 * lane_vertical_margin;
      var y = 0;

      for (var i = 0 ; i < lane_index ; i++) {
        y += lane_box_height;
      }

      return y + lane_box_height / 2;
    }

    var svg = d3.select("#variants-visualization").append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
      .append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    var plot_graph_element = function(element, lane_y, element_height, element_class) {
      var x1 = x_scale(element.start);
      var x2 = x_scale(element.stop);

      var scaled_width = x2 - x1;
      if (scaled_width < minimum_width) {
        scaled_width = minimum_width;
      }

      svg.append("rect")
          .attr("class", element_class)
          .attr("x", x1)
          .attr("y", lane_y - element_height / 2)
          .attr("width", scaled_width)
          .attr("height", element_height);
    }

    // Plot axes
    for (var i = 0 ; i < VariantsApp.lanes_count ; i++) {
      var y = lane_y_position(i);
      svg.append("line")
          .attr("x1", 0)
          .attr("y1", y)
          .attr("x2", width)
          .attr("y2", y);
    }

    // Plot exons
    var exon_lane_y = lane_y_position(0);
    var utr5_stop = VariantsApp.utr5[1];
    var utr3_start = VariantsApp.utr3[0];

    var plot_exon = function(exon) {
      var start = exon.start;
      var stop = exon.stop;

      if (start >= utr5_stop && stop <= utr3_start) {
        // completely outside utrs
        plot_graph_element(exon, exon_lane_y, exon_height, "exon");
      } else if (stop <= utr5_stop || start >= utr3_start) {
        // completely inside utrs
        plot_graph_element(exon, exon_lane_y, exon_in_utr_height, "exon");
      } else {
        // intersecting with utrs

        var intersection = {};
        var rest = {};

        if (start < utr5_stop) {
          intersection.start = start;
          intersection.stop = utr5_stop;
          rest.start = utr5_stop;
          rest.stop = stop;
        } else {
          rest.start = start;
          rest.stop = utr3_start;
          intersection.start = utr3_start;
          intersection.stop = stop;
        }

        plot_graph_element(rest, exon_lane_y, exon_height, "exon");
        plot_graph_element(intersection, exon_lane_y, exon_in_utr_height, "exon");
      }
    }

    for (var i = 0 ; i < data.exons.length ; i++) {
      var exon = data.exons[i];
      plot_exon(exon);
    }

    // Plot utrs
    plot_graph_element(data.utr5, exon_lane_y, utr_height, "utr");
    plot_graph_element(data.utr3, exon_lane_y, utr_height, "utr");

    // Plot changes

    for (var i = 0 ; i < data.changes.length ; i++) {
      var change = data.changes[i];
      var start = change.start;
      var stop = change.stop;

      if (change.stop < VariantsApp.scale_start || change.start > VariantsApp.scale_stop) {
        continue;
      }

      // find first open lane
      var found = false;
      var lane_index;

      for (var j = 0 ; j < VariantsApp.change_lanes.length ; j++) {
        var lane_changes = VariantsApp.change_lanes[j];

        if (lane_changes.length < 1) {
          // lane open
          lane_index = j + 1;
          found = true;
          break;
        }

        var intersecting = false;

        for (var k = 0 ; k < lane_changes.length ; k++) {
          // find out if new change is intersecting with previous change
          var existing_start = lane_changes[k][0];
          var existing_stop = lane_changes[k][1];

          if ((start >= existing_start && start <= existing_stop) || (stop >= existing_start && stop <= existing_stop)) {
            // intersecting
            intersecting = true;
            break;
          }
        }

        if (intersecting) {
          continue;
        } else {
          // this lane can be used
          lane_index = j + 1;
          found = true;
          break;
        }
      }

      var change_lane_y;

      if (!found) {
        // create new lane
        lane_index = VariantsApp.lanes_count;
        VariantsApp.lanes_count = VariantsApp.lanes_count + 1;
        VariantsApp.change_lanes.push([]);

        var new_height = calculate_height(VariantsApp.lanes_count);
        d3.select("#variants-visualization svg").attr("height", new_height);
        y = lane_y_position(lane_index);

        svg.append("line")
          .attr("x1", 0)
          .attr("y1", y)
          .attr("x2", width)
          .attr("y2", y);
      }

      VariantsApp.change_lanes[lane_index - 1].push([start, stop]);
      var changes_lane_y = lane_y_position(lane_index);
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
