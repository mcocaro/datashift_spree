# Copyright:: (c) Autotelik Media Ltd 2011
# Author ::   Tom Statter
# Date ::     Summer 2012
#
# License::   MIT - Free, OpenSource
#
# Details::   Specification for Spree generator aspect of datashift gem.
#
#             Provides Loaders and rake tasks specifically tailored for uploading or exporting
#             Spree Products, associations and Images
#
require File.join(File.expand_path(File.dirname(__FILE__)), "spec_helper")

require 'excel_exporter'
require 'csv_exporter'

describe 'SpreeExporter' do
  
  before(:all) do
    results_clear()
  end


  before(:each) do

    # TODO - to get decent export data could maybe call rake db:seed + rake spree_sample:load 
    # 
    # Create some test data
    root = @Taxonomy_klass.create( :name => 'Paintings' )
 
    @Taxon_klass.create( :name => 'Landscape', :description => "Nice paintings", :taxonomy_id => root.id )
    @Taxon_klass.create( :name => 'Sea', :description => "Waves and sand", :taxonomy_id => root.id )
  end

  it "should export any Spree model to .xls spreedsheet" do

    expect = result_file('taxon_export_spec.xls')

    exporter = DataShift::ExcelExporter.new(expect)

    items = @Taxon_klass.all

    exporter.export(items)

    expect(File.exists?(expect)).to eq true
  end

  it "should export a Spree model and associations to .xls spreedsheet" do

    expect = result_file('taxon_and_assoc_export_spec.xls')

    exporter = DataShift::ExcelExporter.new(expect)

    items = @Taxon_klass.all
      
    exporter.export_with_associations(@Taxon_klass, items)

    expect(File.exists?(expect)).to eq true

  end
  
  
  it "should export Products with all associations to .xls" do

    expected = result_file('products_assoc_export_spec.xls')

    exporter = DataShift::ExcelExporter.new(expected)
      
    exporter.export_with_associations(@Product_klass, @Product_klass.all)

    puts "Exported Products to #{expected}"
    
    expect(File.exists?(expected)).to eq true

  end
  
  
   
  it "should export Products with all associations to CSV" do

    expected = result_file('products_assoc_export_spec.csv')

    exporter = DataShift::CsvExporter.new(expected)
      
    exporter.export_with_associations(@Product_klass, @Product_klass.all)

    puts "Exported Products to #{expected}"
    
    expect(File.exists?(expected)).to eq true

  end
    
end