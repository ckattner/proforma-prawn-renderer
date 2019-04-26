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
    # This class understands how to ender a Proforma::Modeling::Spacer component.
    class SpacerRenderer < Renderer
      AMOUNT = 15

      private_constant :AMOUNT

      def render(_separator)
        pdf.move_down(AMOUNT)
      end
    end
  end
end
