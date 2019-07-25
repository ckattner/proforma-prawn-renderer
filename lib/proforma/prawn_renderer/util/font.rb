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
      # Defines what we & prawn need in a font.
      class Font
        acts_as_hashable

        attr_reader :bold_path,
                    :name,
                    :normal_path

        def initialize(bold_path:, name:, normal_path:)
          raise ArgumentError, 'bold_path is required'    if bold_path.to_s.empty?
          raise ArgumentError, 'name is required'         if name.to_s.empty?
          raise ArgumentError, 'normal_path is required'  if normal_path.to_s.empty?

          @bold_path    = bold_path
          @name         = name
          @normal_path  = normal_path

          freeze
        end

        def prawn_config
          {
            name.to_s => {
              normal: normal_path.to_s,
              bold: bold_path.to_s
            }
          }
        end
      end
    end
  end
end
