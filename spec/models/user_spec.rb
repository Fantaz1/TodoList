require "spec_helper"
require "valid_data"
describe User do
  
  context "assotiations" do 
  
    it { should have_many(:projects).through(:shares) }
    it { should have_many(:shares) }
    it { should have_and_belong_to_many(:tasks) }
  end
  
  context "valid attributes" do
    before(:each) do  
      @user = User.new valid_attributes_user 
    end
    
    it "should require password" do    
      @user.password = nil
      @user.should_not be_valid
    end 
    
    
    it "should require email" do
      @user.email = nil
      @user.should_not be_valid
    end
  end

	context "#shared_projects" do
		before(:each) do
			@user = User.new valid_attributes_user	
			@user.save
			@project = Project.new name:"first", user_id:@user.id
			@project.save
			@user.projects << @project
		end

		it "should return projects that were share for me" do
			@user.shared_projects.count.should == 1
		end
		
		it "should not return projects created by me" do
			@user.shares.last.update_attributes(:author=>true)
			@user.shared_projects.count.should == 0
		end
	end

	context "#my_projects" do
		before(:each) do
			@user = User.new valid_attributes_user
			@user.save			
			project = Project.new name:"first", user_id:@user.id
			project.save
			@user.projects << project
		end

		it "should not return projects that were share for me" do
			@user.my_projects.count.should == 0
		end
		
		it "should return projects created by me" do
			@user.shares.last.update_attributes(:author=>true)
			@user.my_projects.count.should == 1
		end
	end
  
  
end
