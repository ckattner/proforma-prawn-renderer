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
    # This class understands how to ender a Proforma::Modeling::Banner component.
    class BannerRenderer < Renderer
      PAD_LEFT    = [0, 0, 0, 10].freeze
      NO_PADDING  = [0, 0, 0, 0].freeze

      def render(banner)
        pdf.table(
          make_rows(banner),
          width: total_width,
          column_widths: make_column_widths(banner)
        )
      end

      private

      def make_rows(banner)
        row = []
        row << make_image_cell(banner) if banner.image
        row << make_text_cell(banner) unless text_contents(banner).empty?
        [row]
      end

      def make_column_widths(banner)
        column_widths = []

        if banner.image && banner.image_width && !text_contents(banner).empty?
          column_widths << banner.image_width
        end

        column_widths
      end

      def make_text_cell(banner)
        pdf.make_cell(text_contents(banner), text_cell_style(!banner.image.nil?))
      end

      def make_image_cell(banner)
        {
          image: banner.image,
          image_width: banner.image_width,
          image_height: banner.image_height,
          padding: 0,
          border_width: 0
        }
      end

      def text_contents(banner)
        contents = []
        contents << "<b>#{banner.title}</b>" unless banner.title.empty?
        contents << banner.details.to_s unless banner.details.empty?
        contents.join("\n")
      end

      def cell_style
        @cell_style ||= {
          border_width: 0,
          min_font_size: 1,
          overflow: :shrink_to_fit,
          padding: 0,
          size: text_font_size
        }
      end

      def text_cell_style(pad_left)
        padding = pad_left ? PAD_LEFT : NO_PADDING

        cell_style.merge(
          inline_format: true,
          padding: padding
        )
      end
    end
  end
end
