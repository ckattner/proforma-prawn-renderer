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
    # This class understands how to ender a Proforma::Modeling::Header component.
    class HeaderRenderer < Renderer
      def render(text)
        pdf.text(
          text.value.to_s,
          font: font_name,
          size: header_font_size,
          style: bold_font_style
        )
      end
    end
  end
end
