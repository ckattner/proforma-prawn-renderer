# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'renderer'

module Proforma
  class PrawnRenderer
    # This class understands how to ender a Proforma::Modeling::Pane component.
    class PaneRenderer < Renderer
      def render(pane)
        pdf.table(
          make_rows(pane.columns),
          column_widths: make_column_widths(pane.columns),
          width: total_width
        )
      end

      private

      def make_rows_shell(columns)
        total_columns = columns.length * 2
        total_rows = columns.map(&:line_count).max

        (0...total_rows).map { Array.new(total_columns) }
      end

      def value_cell_padding(column_index, total_columns)
        if column_index < total_columns - 1
          [2, 20, 2, 2]
        else
          [2, 0, 2, 2]
        end
      end

      def value_cell_style(column, column_index, total_columns)
        base_value_cell_style.merge(
          align: column.align.to_s.to_sym,
          padding: value_cell_padding(column_index, total_columns)
        )
      end

      def make_rows(columns)
        rows = make_rows_shell(columns)

        columns.each_with_index do |column, column_index|
          value_cell_style = value_cell_style(column, column_index, columns.length)

          populate_lines(column.lines, rows, column_index, value_cell_style)
        end

        rows
      end

      def populate_lines(lines, rows, column_index, value_cell_style)
        label_cell_index = column_index * 2
        value_cell_index = column_index * 2 + 1

        lines.each_with_index do |line, line_index|
          label = line.label
          value = line.value
          rows[line_index][label_cell_index] = pdf.make_cell(label, base_label_cell_style)
          rows[line_index][value_cell_index] = pdf.make_cell(value, value_cell_style)
        end
      end

      def make_column_widths(columns)
        column_widths = {}

        columns.each_with_index do |column, index|
          label_width = column.label_width
          next unless label_width

          column_widths[index * 2] = calculate_width(label_width)
        end

        column_widths
      end

      def base_value_cell_style
        @base_value_cell_style ||= {
          border_width: 0,
          font: font_name,
          padding: [2, 0, 2, 2],
          size: text_font_size
        }
      end

      def base_label_cell_style
        @base_label_cell_style ||= base_value_cell_style.merge(
          padding: [2, 2, 2, 0],
          font_style: bold_font_style
        )
      end
    end
  end
end
