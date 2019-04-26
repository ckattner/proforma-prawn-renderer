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
    # This class understands how to ender a Proforma::Modeling::Table component.
    class TableRenderer < Renderer
      def render(table)
        prototype_row = table.header.rows.first
        column_widths = prototype_row ? make_column_widths(prototype_row) : {}

        pdf.table(
          make_all_rows(table),
          column_widths: column_widths,
          width: total_width
        )
      end

      private

      def make_all_rows(table)
        make_rows(table.header, header_cell_style) +
          make_rows(table.body, body_cell_style) +
          make_rows(table.footer, footer_cell_style)
      end

      def make_rows(section, cell_style)
        section.rows.map do |row|
          row.cells.map do |cell|
            immediate_style = {
              align: cell.align.to_s.to_sym
            }

            pdf.make_cell(cell.text.to_s, cell_style.merge(immediate_style))
          end
        end
      end

      def make_column_widths(row)
        column_widths = {}

        row.cells.each_with_index do |cell, index|
          next unless cell.width

          column_widths[index] = calculate_width(cell.width)
        end

        column_widths
      end

      def cell_style
        @cell_style ||= {
          border_width: 0.5,
          font: font_name,
          padding: 3,
          size: text_font_size
        }
      end

      def body_cell_style
        @body_cell_style ||= cell_style.merge(
          borders: %i[top bottom]
        )
      end

      def header_cell_style
        @header_cell_style ||= cell_style.merge(
          background_color: 'D3D3D3',
          borders: [],
          font_style: bold_font_style
        )
      end

      def footer_cell_style
        @footer_cell_style ||= cell_style.merge(
          background_color: 'F4F4F4',
          borders: [],
          font_style: bold_font_style
        )
      end
    end
  end
end
