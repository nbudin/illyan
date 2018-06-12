namespace :cassy do
  desc "Clean up expired and consumed tickets"
  task :cleanup => :environment do
    $LOG = Rails.logger

    def cleanup_tickets(klass, max_lifetime)
      klass.transaction do
        conditions = ["created_on < ?", Time.now - max_lifetime]
        expired_tickets_count = klass.where(*conditions).count

        $LOG.debug("Destroying #{expired_tickets_count} expired #{klass.name.demodulize}"+
          "#{'s' if expired_tickets_count > 1}.") if expired_tickets_count > 0

        klass.where(*conditions).destroy_all
      end
    end

    cleanup_tickets(Cassy::ProxyGrantingTicket, Cassy.config["maximum_session_lifetime"])

    cleanup_tickets(Cassy::LoginTicket, Cassy.config["maximum_session_lifetime"])
    cleanup_tickets(Cassy::LoginTicket, Cassy.config["maximum_unused_login_ticket_lifetime"])

    cleanup_tickets(Cassy::ServiceTicket, Cassy.config["maximum_session_lifetime"])
    cleanup_tickets(Cassy::ServiceTicket, Cassy.config["maximum_unused_service_ticket_lifetime"])

    cleanup_tickets(Cassy::TicketGrantingTicket, Cassy.config["maximum_session_lifetime"])
  end
end
