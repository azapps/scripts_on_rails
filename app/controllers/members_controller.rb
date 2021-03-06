class MembersController < ApplicationController
  before_filter :authenticate_user!
  authorize_resource

  def crumb
    add_crumb I18n.t('projects.my'), projects_path
    add_crumb @project.name, project_path(@project)
    add_crumb I18n.t('projects.members'), project_members_path(@project)
  end

  # GET /members
  # GET /members.json
  def index
    @project=Project.find(params[:project_id])
    @members = @project.members.all
    self.crumb

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @members }
    end
  end

  # GET /members/1
  # GET /members/1.json
  def show
    @project=Project.find(params[:project_id])
    @member = @project.members.find(params[:id])
    self.crumb
    add_crumb @member.user.email, project_member_path(@project,@member)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @member }
    end
  end

  # GET /members/new
  # GET /members/new.json
  def new
    @project=Project.find(params[:project_id])
    @member = @project.members.new(params[:member])
    self.crumb
    add_crumb I18n.t('members.new'), new_project_member_path(@project)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @member }
    end
  end

  # GET /members/1/edit
  def edit
    @project=Project.find(params[:project_id])
    @member = @project.members.find(params[:id])
    self.crumb
    add_crumb @member.user.email, project_member_path(@project,@member)
    add_crumb I18n.t('members.edit'), edit_project_member_path(@project,@member)
  end

  # POST /members
  # POST /members.json
  def create
    @project=Project.find(params[:project_id])
    @member = @project.members.new(params[:member])

    respond_to do |format|
      if @member.save
        format.html { redirect_to project_members_path(@project), notice: 'Member was successfully created.' }
        format.json { render json: @member, status: :created, location: @member }
      else
        format.html { render action: "new" }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /members/1
  # PUT /members/1.json
  def update
    @project=Project.find(params[:project_id])
    @member = @project.members.find(params[:id])
    if can? :change_rights, @member
      @member.is_admin=params[:member][:is_admin]
      @member.can_create=params[:member][:can_create]
    end
    @member.vars=params[:member][:vars]

    respond_to do |format|
      if @member.save
        format.html { redirect_to project_members_path(@project), notice: 'Member was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.json
  def destroy
    @project=Project.find(params[:project_id])
    @member = @project.members.find(params[:id])
    @member.destroy

    respond_to do |format|
      format.html { redirect_to project_members_url(@project) }
      format.json { head :no_content }
    end
  end
end
