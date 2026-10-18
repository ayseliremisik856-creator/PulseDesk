module TicketsHelper
  def status_label(status)
    { "new" => "Yeni", "open" => "Açık", "solved" => "Çözüldü" }.fetch(status, status)
  end

  def priority_label(priority)
    { "low" => "Düşük", "normal" => "Normal", "high" => "Yüksek", "urgent" => "Acil" }.fetch(priority, priority)
  end

  def sla_label(ticket)
    policy = ticket.sla
    if policy.breached?
      ticket.first_response_at ? "SLA ihlali · geç yanıtlandı" : "Overdue · ilk yanıt gecikti"
    elsif ticket.first_response_at
      "İlk yanıt hedefi karşılandı"
    else
      "İlk yanıt için #{(policy.remaining_seconds / 60).ceil} dk kaldı"
    end
  end
end
