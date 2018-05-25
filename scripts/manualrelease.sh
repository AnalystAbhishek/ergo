#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Exit on first error, print all commands.
set -ev
set -o pipefail

# Make sure we have the latest code from origin/master on our fork
git fetch --all --prune
git checkout master
git merge --ff-only upstream/master
git pull origin master

# Increase the version number
npm run pkgbump
TARGET_VERSION=$( jq -r '.version' lerna.json )
git add mechanization/Version.v
git add package.json
git commit -m "chore(release): Bump Ergo source version" -s

lerna publish --conventional-commits -m 'chore(release): publish %s' --force-publish=* --allow-branch ${RELEASE_BRANCH} --repo-version ${TARGET_VERSION} --yes

# Fix DCO sign-off
NAME=$(git config user.name)
EMAIL=$(git config user.email)

if [ -z "$NAME" ]; then
    echo "empty git config user.name"
    exit 1
fi

if [ -z "$EMAIL" ]; then
    echo "empty git config user.email"
    exit 1
fi
git filter-branch --msg-filter "cat - && echo && echo 'Signed-off-by: ${NAME} <${EMAIL}>'" HEAD

# Merge into upstrea/master
git rebase -i upstream/master

echo "Publish of ${TARGET_VERSION} successful."
echo "Now open a pull request to merge ${RELEASE_BRANCH} into master."