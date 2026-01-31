module Api
  class ContactsController < ApplicationApiController
      before_action :set_contact, only: %i[ show edit update destroy ]

      # GET /api/contacts
      def index
        @contacts = Contact.all
      end

      # GET /contacts/1 or /contacts/1.json
      def show
      end

      # GET /contacts/new
      def new
        @contact = Contact.new
      end

      # GET /contacts/1/edit
      def edit
      end

      # POST /contacts or /contacts.json
      def create
        @contact = Contact.new(contact_params)

        respond_to do |format|
          if @contact.save
            format.json { render :show, status: :created, location: @contact }
            ContactMailer.new_contact_form(@contact.email, @contact.name).deliver_now
          else
            format.json { render json: @contact.errors, status: :unprocessable_entity }
          end
        end
      end

      # PATCH/PUT /contacts/1 or /contacts/1.json
      def update
        respond_to do |format|
          if @contact.update(contact_params)
            format.json { render :show, status: :ok, location: @contact }
          else
            format.json { render json: @contact.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE /contacts/1 or /contacts/1.json
      def destroy
        @contact.destroy!

        respond_to do |format|
          format.json { head :no_content }
        end
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_contact
          @contact = Contact.find(params.expect(:id))
        end

        # Only allow a list of trusted parameters through.
        def contact_params
          params.expect(contact: [ :name, :email, :reason, :phone, :message ])
        end
  end
end
