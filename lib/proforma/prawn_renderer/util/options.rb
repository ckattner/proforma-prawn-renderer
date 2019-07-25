# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Proforma
  class PrawnRenderer
    module Util
      # Defines what is allowed to be customized per rendering.
      class Options
        acts_as_hashable

        attr_reader :bold_font_style,
                    :font_name,
                    :fonts,
                    :header_font_size,
                    :text_font_size

        def initialize(
          bold_font_style: :bold,
          font_name: nil,
          fonts: [],
          text_font_size: 10,
          header_font_size: 15
        )
          @bold_font_style  = bold_font_style
          @font_name        = font_name
          @fonts            = Font.array(fonts)
          @text_font_size   = text_font_size
          @header_font_size = header_font_size

          freeze
        end
      end
    end
  end
end
