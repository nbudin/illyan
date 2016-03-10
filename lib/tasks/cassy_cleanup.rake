namespace :cassy do
  desc "Clean up expired and consumed tickets"
  task :cleanup => :environment do
    $LOG = Rails.logger

    def cleanup_tickets(klass)
      max_lifetime = Cassy.config["maximum_session_lifetime"]

      klass.transaction do
        conditions = ["created_on < ?", Time.now - max_lifetime]
        expired_tickets_count = klass.count(:conditions => conditions)

        $LOG.debug("Destroying #{expired_tickets_count} expired #{klass.name.demodulize}"+
          "#{'s' if expired_tickets_count > 1}.") if expired_tickets_count > 0

        klass.destroy_all(conditions)
      end
    end

    cleanup_tickets(Cassy::ProxyGrantingTicket)

    Cassy::LoginTicket.cleanup(
      Cassy.config["maximum_session_lifetime"],
      Cassy.config["maximum_unused_login_ticket_lifetime"]
    )

    Cassy::ServiceTicket.cleanup(
      Cassy.config["maximum_session_lifetime"],
      Cassy.config["maximum_unused_service_ticket_lifetime"]
    )

    cleanup_tickets(Cassy::TicketGrantingTicket)
  end
end