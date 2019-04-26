# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Proforma
  class PrawnRenderer
    # The base class that contains common functionality across all sub-rendering components.
    class Renderer
      extend Forwardable

      def_delegators :options,
                     :font_name,
                     :header_font_size,
                     :text_font_size

      def initialize(pdf, options)
        @options  = options
        @pdf      = pdf
      end

      private

      attr_reader :options, :pdf

      def bold_font_style
        options.bold_font_style.to_s.to_sym
      end

      def total_width
        pdf.bounds.width
      end

      def calculate_width(percentage)
        return 0 unless percentage

        total_width * (percentage.to_f / 100)
      end
    end
  end
end
