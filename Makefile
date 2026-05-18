.PHONY: lock unlock status time-machine

lock:
	./lazy-lock-sync.sh lock

unlock:
	./lazy-lock-sync.sh unlock

status:
	./lazy-lock-sync.sh status

time-machine:
	./lazy-lock-time-machine.sh $(filter-out $@,$(MAKECMDGOALS))

%:
	@true
