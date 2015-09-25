require 'spec_helper'

describe EmberRoutes::Generator do

  describe '#underscore' do

    let(:path) {
      '/foo/bar'
    }

    let(:result) {
      EmberRoutes::Generator.underscore(path)
    }

    it 'should convert a url path to a ruby path' do
      expect(result).to eq('foo_bar')
    end

    context 'complex chars' do

      let(:path) {
        '/foor-32-34-test/234_sdf-ew'
      }

      it 'should convert to path' do
        expect(result).to eq('foor_32_34_test_234_sdf_ew')
      end

    end

  end

end

describe '#configure' do

  let(:prefix) {
    ''
  }

  let(:base_url) {
    ''
  }

  let(:subject) {
    EmberRoutes.configure do |config|
      config.prefix = prefix
      config.base_url = base_url
      config.routes do
        route 'foo', :path => '/foo' do
          route 'bar', :path => '/bar'
        end
      end
    end
    class Test
      include EmberRoutes::PathHelpers
    end
    Test.new
  }

  it 'should create the methods in the module' do
    expect( subject ).to respond_to(:foo_bar_path)
    expect( subject.root_path).to eq('/')
    expect( subject.foo_path ).to eq('/foo' )
    expect( subject.foo_bar_path ).to eq('/foo/bar' )
  end

  context 'different prefix' do

    let(:prefix) {
      'ember_'
    }

    it 'should add the prefix to the helpers' do
      subject
      expect( subject.ember_root_path ).to eq('/')
      expect( subject.ember_foo_path ).to eq( '/foo')
    end

  end

  context 'different base url' do

    let(:base_url) {
      '/frontend'
    }

    it 'should alter the urls' do
      subject
      expect( subject.root_path ).to eq('/frontend/')
      expect( subject.foo_path ).to eq('/frontend/foo' )
    end

  end

  it 'should format the parameters' do
    subject
    expect( subject.root_path( { :foo => 'test' } ) ).to eq('/?foo=test')
    expect( subject.root_path( { :foo => 'test', :blah => 10 } ) ).to eq('/?foo=test&blah=10')
    expect( subject.root_path(:foo => 'test') ).to eq('/?foo=test')
    expect( subject.root_path(:foo => 'test', :blah => 43) ).to eq('/?foo=test&blah=43')
  end

  context 'paths with parameters' do

    subject {
      EmberRoutes.configure do |config|
        config.prefix = prefix
        config.base_url = base_url
        config.routes do
          route :foo, :path => '/foo' do
            route :index, :path => '/:id'
          end
        end
      end
      class Test
        include EmberRoutes::PathHelpers
      end
      Test.new
    }

    it 'should require parameters for paths' do
      expect( subject ).to respond_to(:foo_path)
      expect( subject.foo_path ).to eq('/foo')
      expect( subject.foo_index_path(:id => 42)).to eq('/foo/42')
    end

  end

end
