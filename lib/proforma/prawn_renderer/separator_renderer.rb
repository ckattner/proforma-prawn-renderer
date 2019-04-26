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
    # This class understands how to ender a Proforma::Modeling::Separator component.
    class SeparatorRenderer < Renderer
      WIDTH = 0.5

      private_constant :WIDTH

      def render(_separator)
        pdf.line_width(WIDTH)
        pdf.stroke_horizontal_rule
        pdf.move_down(5)
      end
    end
  end
end
