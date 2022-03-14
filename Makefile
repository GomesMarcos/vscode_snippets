# This Makefile'll turn your life easier. =)
# Author: Marcos Gomes
# GitHub: https://github.com/GomesMarcos/

guard-%:
	@ if [ "${${*}}" = "" ]; then \
		echo "the variable \"$*\" is required."; \
		exit 1; \
	fi

clean:
	find . -type d -name __pycache__ -exec rm -r {} \+ && find . -type d -name .pytest_cache -exec rm -r {} \+

collect_tests:
	pytest --collect-only

cover:
	coverage run --source=src/ -m pytest -vv tests/ && coverage report -m

cover_html:
	coverage html && firefox htmlcov/index.html

delete_local_branch: guard-name
	git branch -D ${name}

delete_remote_origin_branch: guard-name
	git push origin --delete ${name}

install:
	pip install -r requirements.txt

install_dev:
	pip install -r requirements_dev.txt

kill_flask:
	# Caso dê erro de porta já sendo usada, rode este comando.
	lsof -t -i tcp:5000 | xargs kill -9 

commit: guard-text
	git add . && git reset run.py && git commit -m"${text}"

feature: guard-name
	git checkout -b feature/${name} develop && git pull origin develop && git push -u origin feature/${name}

feature_by_current_branch: guard-name
	git checkout -b feature/${name} $(shell git symbolic-ref --short HEAD)
	git push -u origin feature/${name}

hotfix: guard-name
	git checkout -b hotfix/${name} main && git pull origin main

release: guard-name
	git checkout -b release/v.${name} develop && git pull origin develop && git push -u origin release/v.${name}

release_by_current_branch: guard-name
	git checkout -b release/v.${name} $(shell git symbolic-ref --short HEAD) && git push -u origin release/v.${name}

tag: guard-name guard-text
	git checkout master && git pull origin master && git tag -a ${name} -m"${text}" master  && git push origin ${name} && git tag

solve_conflict: guard-destiny guard-working
	git checkout ${destiny} && git pull origin ${destiny} && git checkout -b conflict/${destiny}_with_${working} && git push -u origin conflict/${destiny}_with_${working} && git merge origin/${working}
	
solve_conflict_current_branch: guard-destiny
	git checkout ${destiny} && git pull origin ${destiny} && git checkout -b conflict/${destiny}_with_$(shell git branch --show-current) && git push -u origin conflict/${destiny}_with_$(shell git branch --show-current) && git merge origin/$(shell git branch --show-current)

test_verbose_with_print:
	pytest -svv tests/

undo_last_commit: guard-qtd
	git reset HEAD~1

view_commits_current_branch:
	git log --oneline

venv:
	python<version> -m venv venv
