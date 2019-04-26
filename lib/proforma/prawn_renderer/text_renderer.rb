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
    # This class understands how to ender a Proforma::Modeling::Text component.
    class TextRenderer < Renderer
      def render(text)
        pdf.text(
          text.value.to_s,
          font: font_name,
          size: text_font_size
        )
      end
    end
  end
end
