# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require './spec/spec_helper'

describe ::Proforma::PrawnRenderer::Util::BalancedSet do
  describe '#calculate' do
    specify 'with no explicit values' do
      expect(described_class.calculate([nil], 100)).to            eq([100])
      expect(described_class.calculate([nil, nil], 100)).to       eq([50, 50])
      expect(described_class.calculate([nil, nil, nil], 100)).to  eq([33.34, 33.33, 33.33])
    end

    specify 'with some explicit values' do
      expect(described_class.calculate([50, nil], 100)).to          eq([50, 50])
      expect(described_class.calculate([46.53, nil, nil], 100)).to  eq([46.53, 26.73, 26.74])
    end

    specify 'with all explicit values' do
      expect(described_class.calculate([50, 50], 100)).to eq([50, 50])
      expect(described_class.calculate([50, 41, 30], 100)).to eq([43, 34, 23])
      expect(described_class.calculate([2, 40, 37], 100)).to  eq([9, 47, 44])
    end
  end
end
