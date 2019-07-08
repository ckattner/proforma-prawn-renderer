# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Proforma
  class PrawnRenderer
    # This class can balance out an un-even set of values.
    class BalancedSet
      class << self
        def calculate(values, sum, round: 2)
          free_spots = values.count(&:nil?)

          if free_spots.positive?
            available_value = sum - values.map(&:to_i).reduce(0, :+)

            new_values = divide(free_spots, available_value, round)

            values = values.map { |v| v || new_values.shift }
          end

          balance(values, sum, round)
        end

        private

        def balance(values, sum, round)
          difference = sum - values.sum

          return values if difference.zero?

          diff_spots = divide(values.length, difference, round)

          values.map.with_index { |value, index| value + diff_spots[index] }
        end

        def divide(count, sum, round)
          spot_value = (sum / count.to_f).round(round)

          remainder = sum - (spot_value * count)

          Array.new(count) { |i| i.zero? ? spot_value + remainder : spot_value }
        end
      end
    end
  end
end
