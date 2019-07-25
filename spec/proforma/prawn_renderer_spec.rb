# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe ::Proforma::PrawnRenderer do
  let(:snapshot_dir) { File.join('spec', 'fixtures', 'snapshots', '*.yml') }

  let(:snapshot_filenames) { Dir[snapshot_dir] }

  it 'should process each snapshot successfully' do
    snapshot_filenames.each do |file|
      contents = yaml_read(file)

      documents = Proforma.render(
        contents['data'],
        contents['template'],
        renderer: Proforma::PrawnRenderer.new
      )

      documents.each_with_index do |document, index|
        expected_strings = contents['strings'][index]

        actual_strings = pdf_strings(document.contents)

        expect(actual_strings).to eq(expected_strings)
      end
    end
  end

  specify 'Proforma Rendering Example' do
    data = [
      { id: 1, name: 'Chicago Bulls' },
      { id: 2, name: 'Indiana Pacers' },
      { id: 3, name: 'Boston Celtics' }
    ]

    template = {
      title: 'nba_team_list',
      children: [
        { type: 'Header', value: 'NBA Teams' },
        { type: 'Separator' },
        {
          type: 'DataTable',
          columns: [
            { header: 'Team ID #', body: '$id' },
            { header: 'Team Name', body: '$name' }
          ]
        }
      ]
    }

    actual_documents = Proforma.render(data, template, renderer: Proforma::PrawnRenderer.new)

    actual_document = actual_documents.first

    expected_strings = 'NBA Teams Team ID # Team Name 1'\
                       ' Chicago Bulls 2 Indiana Pacers 3 Boston Celtics'

    expect(pdf_strings(actual_document.contents)).to eq(expected_strings)
    expect(actual_document.title).to                 eq('nba_team_list')
    expect(actual_document.extension).to             eq('.pdf')
  end

  specify 'a pdf-to-pdf comparison should be equal' do
    pdf     = read(File.join('spec', 'fixtures', 'component_test.pdf'))
    config  = yaml_read(File.join('spec', 'fixtures', 'component_test.yml'))

    documents = Proforma.render(
      config['data'],
      config['template'],
      renderer: Proforma::PrawnRenderer.new
    )

    expect(documents.first.contents).to eq(pdf)
  end

  specify 'panes with un-even column widths equalize' do
    data = [
      { id: 1, name: 'Chicago Bulls' },
      { id: 2, name: 'Indiana Pacers' },
      { id: 3, name: 'Boston Celtics' }
    ]

    template = {
      children: [
        {
          type: 'Pane',
          columns: [
            {
              label_width: '0.5',
              value_width: '',
              lines: [
                { label: 'Label', value: 'Value' }
              ]
            },
            {
              label_width: '10',
              value_width: '',
              lines: [
                { label: 'Label', value: 'Value' }
              ]
            }
          ]
        }
      ]
    }

    actual_documents = Proforma.render(data, template, renderer: Proforma::PrawnRenderer.new)

    expect(actual_documents.length).to eq(1)
  end

  specify 'Custom fonts can be used' do
    data = [{ name: '井友' }]

    template = {
      children: [
        { type: 'Header', value: '井友' },
        { type: 'Header', value: 'Text - 井友' },
        { type: 'Separator' },
        {
          type: 'DataTable',
          columns: [
            { header: '井友', body: '$name' }
          ]
        }
      ]
    }

    options = {
      font_name: 'Tuffy',
      fonts: [
        {
          bold_path: File.join(Dir.pwd, 'spec', 'fixtures', 'fonts', 'Tuffy_Bold.ttf'),
          name: 'Tuffy',
          normal_path: File.join(Dir.pwd, 'spec', 'fixtures', 'fonts', 'Tuffy.ttf')
        }
      ]
    }

    renderer = Proforma::PrawnRenderer.new(options)

    actual_documents = Proforma.render(data, template, renderer: renderer)

    expect(actual_documents.length).to eq(1)
  end
end
