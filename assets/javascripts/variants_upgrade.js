var create_visualization = function() {
  var dataset;
  var transcript_id = getUrlParameter('transcript');

  var plot_data = function(data) {
    // Change these to fine-tune graph
    var domain_padding = 1000;
    var margin = { top: 20, right: 10, bottom: 20, left: 10 };
    var width = 1200 - margin.left - margin.right;
    var lane_height = 150;
    var lane_vertical_margin = 5;
    var exon_on_screen_percentage = 0.65;
    var minimum_width = 2;
    var tick_count = 80;
    var bold_tick_interval = 5;
    //////////////////////////////////

    // *** UTIL FUNCTIONS *** //

    var calculate_height = function(lanes_count) {
      return lanes_count * (lane_height + 2 * lane_vertical_margin);
    }

    var lane_y_position = function(lane_index) {
      var lane_box_height = lane_height + 2 * lane_vertical_margin;
      var y = 0;

      for (var i = 0 ; i < lane_index ; i++) {
        y += lane_box_height;
      }

      return y + lane_box_height / 2;
    }

    // ********************** //

    var VariantsApp = {};
    VariantsApp.lanes_count = 3;

    var height = calculate_height(VariantsApp.lanes_count);
    var exon_height = Math.round(lane_height * 0.75);
    var exon_in_utr_height = Math.round(exon_height * 0.5);
    var utr_height = Math.round(exon_height * 0.3);
    var change_height = utr_height;
    var regular_tick_height = Math.round(lane_height * 0.15);
    var bold_tick_height = Math.round(lane_height * 0.25);


    // *** EXTRACTING DOMAIN *** //

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

    // ************************* //

    // *** SCALE *** //

    var create_regions = function(data) {
      VariantsApp.regions = [];

      var utr5_start = VariantsApp.utr5[0];
      var utr5_stop = VariantsApp.utr5[1];
      var utr3_start = VariantsApp.utr3[0];
      var utr3_stop = VariantsApp.utr3[1];

      VariantsApp.regions.push({ type: 'intron', start: VariantsApp.scale_start, stop: utr5_start });
      VariantsApp.regions.push({ type: 'utr', start: utr5_start, stop: utr5_stop });

      var exons_of_interest = [];

      for (var i = 0 ; i < data.exons.length ; i++) {
        var exon = data.exons[i];
        var exon_start = exon.start;
        var exon_stop = exon.stop;

        if (exon_stop <= utr5_stop || exon_start >= utr3_start) {
          // completely inside utr, we can skip it
        } else if (exon_start >= utr5_stop && exon_stop <= utr3_start) {
          // completely outside of utrs
          exons_of_interest.push([exon_start, exon_stop]);
        } else {
          // intersecting with utrs, we're interested in not intersecting part
          var not_intersecting_part_start;
          var not_intersecting_part_stop;

          if (exon_start < utr5_stop) {
            not_intersecting_part_start = utr5_stop;
            not_intersecting_part_stop = exon_stop;
          } else {
            not_intersecting_part_start = exon_start;
            not_intersecting_part_stop = utr3_start;
          }

          exons_of_interest.push([not_intersecting_part_start, not_intersecting_part_stop]);
        }
      }

      var last_part_stop = utr5_stop;

      for (var i = 0 ; i < exons_of_interest.length ; i++) {
        var exon = exons_of_interest[i];
        var exon_start = exon[0];
        var exon_stop = exon[1];

        if (last_part_stop < exon_start) {
          VariantsApp.regions.push({ type: 'intron', start: last_part_stop, stop: exon_start });
        }

        VariantsApp.regions.push({ type: 'exon', start: exon_start, stop: exon_stop });
        last_part_stop = exon_stop;
      }

      VariantsApp.regions.push({ type: 'utr', start: utr3_start, stop: utr3_stop });
      VariantsApp.regions.push({ type: 'intron', start: utr3_stop, stop: VariantsApp.scale_stop });
    }

    var calculate_scale_factors = function(data) {
      var scale_size = VariantsApp.scale_stop - VariantsApp.scale_start;

      create_regions(data);

      var sums = {
        'exon': 0,
        'utr': 0,
        'intron': 0
      };

      for (var i = 0 ; i < VariantsApp.regions.length ; i++) {
        var region = VariantsApp.regions[i];

        var length = region.stop - region.start;
        sums[region.type] += length;
      }

      var intron_scaling_factor = width * (1 - exon_on_screen_percentage) / (scale_size - sums['exon']);

      VariantsApp.scale_factors = {
        'exon': width * exon_on_screen_percentage / sums['exon'],
        'intron': intron_scaling_factor,
        'utr': intron_scaling_factor,
      }
    }

    calculate_scale_factors(data);

    var x_scale = function(x) {
      var passed_size = {
        'exon': 0,
        'intron': 0,
        'utr': 0
      };

      for (var i = 0 ; i < VariantsApp.regions.length ; i++) {
        var region = VariantsApp.regions[i];

        if (region.stop < x) {
          var length = region.stop - region.start;
          passed_size[region.type] += length;
        } else {
          var length = x - region.start;
          passed_size[region.type] += length;
          break;
        }
      }

      var result = 0;
      var types = ['exon', 'intron', 'utr'];
      for (var i = 0 ; i < types.length ; i++) {
        type = types[i];
        result += VariantsApp.scale_factors[type] * passed_size[type];
      }

      return result;
    }

    // ************* //

    // *** DRAWING *** //

    var svg = d3.select("#variants-visualization").append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
      .append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    var draw_rectangle = function(x, y, width, height, rect_class, url) {
      var parent_container = svg;

      if (url) {
        parent_container = parent_container.append("a")
              .attr("xlink:href", url)
              .attr("target", "_blank")
      }

      parent_container.append("rect")
          .attr("class", rect_class)
          .attr("x", x)
          .attr("y", y)
          .attr("width", width)
          .attr("height", height);
    }

    var plot_graph_element = function(element, lane_y, element_height, element_class, is_change) {
      var x1 = x_scale(element.start);
      var x2 = x_scale(element.stop);

      var scaled_width = x2 - x1;
      if (scaled_width < minimum_width) {
        scaled_width = minimum_width;
      }

      draw_rectangle(x1, lane_y - element_height / 2, scaled_width, element_height, element_class, false);
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

    var tick_lane_y = lane_y_position(0);

    var plot_ticks = function() {
      var domain_length = VariantsApp.utr3[1] - VariantsApp.utr5[0];
      var step = domain_length / tick_count;

      var start = VariantsApp.utr5[0];
      for (var i = 0 ; i < tick_count ; i++) {
        if (i % bold_tick_interval == 0 || i == tick_count - 1) {
          draw_rectangle(x_scale(start), tick_lane_y - bold_tick_height / 2, 2, bold_tick_height, 'tick', false);
        } else {
          draw_rectangle(x_scale(start), tick_lane_y - regular_tick_height / 2, 1, regular_tick_height, 'tick', false);
        }
        start += step;
      }
    }

    plot_ticks();

    // Plot exons
    var exon_lane_y = lane_y_position(1);
    var utr5_stop = VariantsApp.utr5[1];
    var utr3_start = VariantsApp.utr3[0];

    var plot_exon = function(exon) {
      var start = exon.start;
      var stop = exon.stop;

      if (start >= utr5_stop && stop <= utr3_start) {
        // completely outside utrs
        plot_graph_element(exon, exon_lane_y, exon_height, "exon", false);
      } else if (stop <= utr5_stop || start >= utr3_start) {
        // completely inside utrs
      } else {
        // intersecting with utrs
        var rest = {};

        if (start < utr5_stop) {
          rest.start = utr5_stop;
          rest.stop = stop;
        } else {
          rest.start = start;
          rest.stop = utr3_start;
        }

        plot_graph_element(rest, exon_lane_y, exon_height, "exon", false);
      }
    }

    for (var i = 0 ; i < data.exons.length ; i++) {
      var exon = data.exons[i];
      plot_exon(exon);
    }

    // Plot utrs
    plot_graph_element(data.utr5, exon_lane_y, utr_height, "utr", false);
    plot_graph_element(data.utr3, exon_lane_y, utr_height, "utr", false);

    // *************** //
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
