require 'spec_helper'

describe Api::RepositoriesController do
  include LoginHelperMethods

  before(:each) do
    @product = Product.new
    @organization = Organization.new
    @organization.id = 1
    @request.env["HTTP_ACCEPT"] = "application/json"
    login_user_api
  end

  describe "create a repository" do
    it 'should call pulp and candlepin layer' do
      Product.should_receive(:find_by_cp_id).with('product_1').and_return(@product)
      @product.should_receive(:add_repo).and_return({})

      post 'create', :name => 'repo_1', :url => 'http://www.repo.org', :product_id => 'product_1'
    end

    context 'there is already a repo for the product with the same name' do
      before do
        Product.stub(:find_by_cp_id => @product)
        @product.stub(:add_repo).and_return { raise Errors::ConflictException }
      end

      it "should notify about conflict" do
        post 'create', :name => 'repo_1', :url => 'http://www.repo.org', :product_id => 'product_1'
        response.code.should == '409'
      end
    end

  end

  describe "get a listing of repositories" do
    it 'should list only enabled repositories' do
      Repository.should_receive(:where).with(hash_including(:enabled => true)).and_return([])
      get 'index'
    end

    it 'should list all repositories' do
      Repository.should_receive(:all).and_return([])
      get 'index', :include_disabled => true
    end
  end

  describe "show a repository" do
    it 'should call pulp glue layer' do
      repo_mock = mock(Glue::Pulp::Repo)
      Repository.should_receive(:find).with("1").and_return(repo_mock)
      repo_mock.should_receive(:to_hash)
      get 'show', :id => '1'
    end
  end

  describe "repository discovery" do
    it "should call Pulp::Proxy.post" do
      url  = "http://url.org"
      type = "yum"

      Pulp::Repository.should_receive(:start_discovery).with(url, type).once.and_return({})
      Organization.stub!(:first).and_return(@organization)

      post 'discovery', :organization_id => "ACME", :url => url, :type => type
    end
  end

  describe "get list of repository package groups" do
    subject { get :package_groups, :id => "123" }
    before do
        @repo = Repository.new(:pulp_id=>"123", :id=>"123")
        Repository.stub(:find).and_return(@repo)
        Pulp::PackageGroup.stub(:all => {})
    end
    it "should call Pulp layer" do
      Pulp::PackageGroup.should_receive(:all).with("123")
      subject
    end
    it { should be_success }
  end

  describe "get list of repository package categories" do
    subject { get :package_group_categories, :id => "123" }

    before do
        @repo = Repository.new(:pulp_id=>"123", :id=>"123")
        Repository.stub(:find).and_return(@repo)
        Pulp::PackageGroupCategory.stub(:all => {})
    end
    it "should call Pulp layer" do
      Pulp::PackageGroupCategory.should_receive(:all).with("123")
      subject
    end
    it { should be_success }
  end

end
