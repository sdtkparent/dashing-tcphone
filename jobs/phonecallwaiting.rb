SCHEDULER.every '15m', :first_in => 0 do |job|
	builds=config[:builds].map{|currentWaitingCalls=JSON(get("http://iaonuccx01.sdt.local:9080/realtime/AgentCSQStats"))[0]['currentWaitingCalls']?'ok':'failing'
		{:currentWaitingCalls => currentWaitingCalls}
	}
	failing_builds=builds.find_all{|build| build[:status]!='ok'}
		send_event('travis_builds', {
		:items => builds.map{|build| {:label => "#{build[:repo]} #{build[:status]}"}},
		:moreinfo => "#{failing_builds.length}/#{builds.length} failing",
		:status => (failing_builds.length>0?'warning':'ok')
	})
end