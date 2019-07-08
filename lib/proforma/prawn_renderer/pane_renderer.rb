# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'balanced_set'
require_relative 'renderer'

module Proforma
  class PrawnRenderer
    # This class understands how to ender a Proforma::Modeling::Pane component.
    class PaneRenderer < Renderer
      def render(pane)
        rows = make_rows(pane.columns)

        return unless rows&.length&.positive?

        pdf.table(
          make_rows(pane.columns),
          column_widths: make_column_widths(pane.columns),
          width: total_width
        )
      end

      private

      def make_rows_shell(columns)
        total_columns = columns.length * 2
        total_rows = columns.map(&:line_count)&.max || 0

        (0...total_rows).map do
          (0...total_columns).map do
            pdf.make_cell('', base_value_cell_style)
          end
        end
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
        widths = columns.map { |col| [col.label_width, col.value_width] }.flatten

        BalancedSet.calculate(widths, 100)
                   .map
                   .with_index { |v, i| [i, calculate_width(v)] }
                   .to_h
      end

      def base_value_cell_style
        @base_value_cell_style ||= {
          border_width: 0,
          font: font_name,
          min_font_size: 1,
          overflow: :shrink_to_fit,
          padding: [2, 0, 2, 2],
          size: text_font_size
        }
      end

      def base_label_cell_style
        @base_label_cell_style ||= base_value_cell_style.merge(
          font_style: bold_font_style,
          padding: [2, 2, 2, 0]
        )
      end
    end
  end
end
