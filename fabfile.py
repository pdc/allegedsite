# -*-coding: UTF-8 -*-
# Run these commands with fab

import os
from fabric.api import local, settings, abort, run, cd, env, prefix
from fabric.contrib.console import confirm
from fabric.contrib.files import exists

import logging
logging.basicConfig(level=logging.INFO)

env.hosts = ['alleged@spreadsite.org']
env.site_name = 'alleged'
env.virtualenv = env.site_name
env.settings_subdir = env.site_name
env.django_apps = ['blog', 'snaptioner', 'frontpage']
env.src_dir = 'src'
env.bin_dir = '/home/alleged/bin'


def update_requirements():
    local("pipenv lock -r > requirements.txt")


def test():
    with settings(warn_only=True):
        result = local('pipenv run python manage.py test --keepdb --fail', capture=True)
    if result.failed and not confirm("Tests failed. Continue anyway?"):
        abort("Aborting at user request.")


def push():
    local('git push')


def mkdir(dir_path):
    run('if [ ! -d {0} ]; then mkdir {0}; fi'.format(dir_path))


def install_tclhtml():
    mkdir(env.src_dir)
    mkdir(env.bin_dir)

    tclhtml_dir = os.path.join(env.src_dir, 'tclhtml')

    if not exists(tclhtml_dir):
        with cd(env.src_dir):
            run('git clone git://github.com/pdc/tclhtml.git')
    with cd(tclhtml_dir):
        run('rm -f install.html')
        run('git pull')
        run('./configure --prefix=/home/{0}'.format(env.site_name))
        run('make install')


def deploy():
    test()
    push()

    install_tclhtml()

    mkdir('static')
    mkdir('cache')

    code_dir = '/home/{0}/Sites/{0}'.format(env.site_name)
    with cd(code_dir):
        run('git pull')

        with prefix('. /home/{0}/virtualenvs/{1}/bin/activate'.format(env.site_name, env.virtualenv)):
            run('. ~/.nvm/nvm.sh && npm install')
            run('. ~/.nvm/nvm.sh && npm install -g less less-plugin-clean-css')
            run('. ~/.nvm/nvm.sh && make')  # This makes CSS and may update requirements.txt
            run('pip install -r requirements.txt')
            run('envdir /service/%s/env ./manage.py collectstatic --noinput' % (env.site_name,))

        with cd('pregenerated'):
            run('thmkmf -r ../web')
            run('make install')

    # run('touch /etc/uwsgi/emperor.d/{0}.ini'.format(env.site_name))
