# Site Improvements Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Nine independent improvements: remove back buttons and dead placeholders, floating-card button restyle, teal highlight-block reading links, graphite dark mode, admin gallery scroll-load, Ahoy analytics dashboard, contact messages in admin, TOTP 2FA replacing Twilio, and SES-backed SMTP via Terraform.

**Architecture:** Rails 8.1 monolith (Shakapacker + Stimulus + Turbo frontend, Sidekiq worker, PostgreSQL). Infra is Helm (`infrastructure/helm`) + Terraform (`infrastructure/terraform`) with secrets in AWS SSM Parameter Store delivered by External Secrets Operator. Each task is independently shippable; later tasks never depend on earlier ones except where an "Interfaces" block says so.

**Tech Stack additions:** `chartkick ~> 5.2` + `groupdate ~> 6.8` (gems), `chartkick@5.0.1` + `chart.js@4.5.1` (yarn), `rotp ~> 6.3`, `rqrcode ~> 3.2`. Removes `twilio-ruby`.

## Global Constraints

- Dev commands run inside containers via the `tasks` script: `./tasks rspec`, `./tasks rails`, `./tasks bundle`, `./tasks yarn`, `./tasks rubocop`. Container must be running (`./tasks start`).
- Jest: `./tasks yarn test`. Lint JS/SCSS: `./tasks yarn lint`. Ruby lint: `./tasks rubocop`.
- Gem/npm versions above were verified against RubyGems/npm on 2026-07-05 — pin exactly as written.
- **No code comments** unless stating a non-obvious constraint or workaround (user rule). Never restate what code does.
- **No Claude attribution anywhere** — commit messages, code, docs. No `Co-Authored-By: Claude` lines.
- Commit message style: scope prefix matching repo history (`app:`, `helm:`, `terraform:`, `docker:`), imperative, lowercase.
- Work on a feature branch off `main` (e.g. `site-improvements`), one commit per task minimum.
- Colours: ink `rgb(0,0,0)`/existing `$dark`, theme teal `rgb(75,149,152)`, graphite dark background `rgb(24,27,32)`, destructive red `rgb(160,40,40)`.
- All new hover/motion styles must also apply on `:focus-visible` and respect `prefers-reduced-motion`.

---

### Task 1: Remove back buttons and dead notification placeholders

**Files:**
- Modify: `app/views/posts/show.html.erb:32`
- Modify: `app/views/code_snippets/show.html.erb:49`
- Modify: `app/views/admins/notifications.html.erb`

**Interfaces:**
- Produces: `app/views/admins/notifications.html.erb` reduced to only the "Contact Emails" section (Task 7 replaces its placeholder body with a real list).

- [ ] **Step 1: Find any specs asserting the removed content**

Run: `grep -rn "Back to all\|Say Hellos\|Blog Comments" spec/`
Expected: hits (if any) in view/request/feature specs — note them for Step 3.

- [ ] **Step 2: Remove the two public back buttons**

In `app/views/posts/show.html.erb` delete the line:

```erb
    <a href='<%= posts_path %>' class='standard-button'>Back to all posts</a>
```

In `app/views/code_snippets/show.html.erb` delete the line:

```erb
  <a href='<%= code_snippets_path %>' class='standard-button'>Back to all snippets</a>
```

If either was the only child of a wrapping container div (check the surrounding 3 lines), delete the now-empty wrapper too.

- [ ] **Step 3: Trim the notifications view**

Replace the full contents of `app/views/admins/notifications.html.erb` with:

```erb
<% content_for :section_subtitle do %>
  Notifications
<% end %>

<div class='dashboard-item-container'>
  <h3>
    Contact Emails
  </h3>
  Placeholder
</div>
```

Update or delete any spec assertions found in Step 1 (delete assertions about "Back to all…", "Say Hellos", "Blog Comments"; keep the files).

- [ ] **Step 4: Run the affected specs**

Run: `./tasks rspec spec/requests/posts_request_spec.rb spec/requests/code_snippets_request_spec.rb spec/requests/admins_request_spec.rb`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add app/views spec
git commit -m "app: remove back buttons and dead notification placeholders"
```

---

### Task 2: Floating-card button restyle

**Files:**
- Modify: `app/frontend/packs/styles/base/_colors.scss`
- Modify: `app/frontend/packs/styles/components/_buttons.scss`
- Modify: admin form views that render `Return` links and `Remove` submits (list in Step 3)

**Interfaces:**
- Produces: `.standard-button`/`.input-submit` = primary floating card; modifier class `.secondary` (white card) and existing `.destroy-button` (destructive red text card). Task 4 later re-points the colour variables at CSS custom properties — use `colors.$…` variables only, no literal colours except in `_colors.scss`.

- [ ] **Step 1: Add new colour tokens**

In `app/frontend/packs/styles/base/_colors.scss` append:

```scss
$destructive: rgb(160, 40, 40);
$button-shadow: 0 1px 3px rgba(0, 0, 0, 0.1), 0 4px 14px rgba(0, 0, 0, 0.1);
$button-shadow-hover: 0 2px 6px rgba(0, 0, 0, 0.1), 0 10px 24px rgba(0, 0, 0, 0.16);
```

- [ ] **Step 2: Rewrite the button styles**

In `app/frontend/packs/styles/components/_buttons.scss`, replace the `.standard-button`, `.input-submit`, and `.destroy-button` rules with:

```scss
@mixin floating-card-button {
  background: colors.$dark;
  border: unset;
  border-radius: 10px;
  box-shadow: colors.$button-shadow;
  box-sizing: border-box;
  color: colors.$light;
  cursor: pointer;
  font-family: typography.$general-font;
  font-size: inherit;
  font-weight: 500;
  letter-spacing: 0.05rem;
  line-height: 1em;
  padding: 14px 28px;
  position: relative;
  text-align: center;
  text-decoration: none;
  transition: transform 0.2s cubic-bezier(0.22, 1, 0.36, 1), box-shadow 0.2s ease;
  user-select: none;
  vertical-align: middle;
  white-space: nowrap;

  &:hover,
  &:focus-visible {
    box-shadow: colors.$button-shadow-hover;
    transform: translateY(-2px);
  }

  &:active {
    transform: translateY(0);
  }

  &.secondary {
    background: colors.$background-color;
    color: colors.$darker-font;
  }
}

.standard-button {
  @include floating-card-button;
}

.input-submit {
  @include floating-card-button;
  align-items: center;
  display: inline-flex;
  height: 3em;
  justify-content: center;
  min-width: 110px;
}

.destroy-button {
  background: colors.$background-color;
  color: colors.$destructive;
  margin-top: 10px;
}

@media (prefers-reduced-motion: reduce) {
  .standard-button,
  .input-submit {
    transition: none;

    &:hover,
    &:focus-visible {
      transform: none;
    }
  }
}
```

Keep the rest of the file (`.menu-button`, `.embedded-gallery-button`, etc.) unchanged. Note `_buttons.scss` already has `@use '../base/colors'` and `@use '../base/typography'` at the top.

- [ ] **Step 3: Tag secondary buttons in views**

Run: `grep -rln "standard-button input-submit" app/views`

For every hit (expected: `admin/posts/_new_form`, `admin/posts/_edit_form`, `admin/code_snippets/_new_form`, `admin/code_snippets/_edit_form`, `admin/projects/_new_form`, `admin/projects/_edit_form`, `admin/gallery_images/_new_form`, `admin/gallery_images/_edit_form`), change the `Return` link class from `'standard-button input-submit'` to `'standard-button input-submit secondary'`.

- [ ] **Step 4: Lint and test**

Run: `./tasks yarn lint && ./tasks rspec spec/feature`
Expected: stylelint clean; feature specs PASS (they click these buttons — failures here mean a selector broke, fix the view not the spec).

- [ ] **Step 5: Visual check**

Run: `./tasks start`, open `http://localhost:3000/contact` and an admin form; confirm lift-on-hover and the three variants read correctly.

- [ ] **Step 6: Commit**

```bash
git add app/frontend app/views
git commit -m "app: restyle buttons as floating cards with secondary and destructive variants"
```

---

### Task 3: Teal highlight-block links in reading content

**Files:**
- Modify: `app/frontend/packs/styles/base/_colors.scss`
- Modify: `app/frontend/packs/styles/base/_typography.scss`

**Interfaces:**
- Consumes: nothing. Produces: `.reading-pane a` highlight style driven by `colors.$link-highlight` (Task 4 converts the token to a CSS custom property — keep the rgba literal ONLY in `_colors.scss`).

- [ ] **Step 1: Add the highlight token**

In `app/frontend/packs/styles/base/_colors.scss` append:

```scss
$link-highlight: rgba(75, 149, 152, 0.65);
```

- [ ] **Step 2: Style reading-pane links**

In `app/frontend/packs/styles/base/_typography.scss`, inside the existing `.reading-pane` block, add:

```scss
  a {
    color: inherit;
    position: relative;
    text-decoration: none;
    z-index: 1;

    &::before {
      background: colors.$link-highlight;
      bottom: 0;
      content: '';
      height: 1.5px;
      left: -2px;
      position: absolute;
      right: -2px;
      transition: height 0.22s cubic-bezier(0.22, 1, 0.36, 1);
      z-index: -1;
    }

    &:hover::before,
    &:focus-visible::before {
      height: calc(100% + 4px);
    }
  }

  @media (prefers-reduced-motion: reduce) {
    a::before {
      transition: none;
    }
  }
```

- [ ] **Step 3: Lint + visual check**

Run: `./tasks yarn lint`
Expected: clean.

Open a blog post with links (`http://localhost:3000/blog`) — links show a thin teal underline that grows to a full highlight block on hover.

- [ ] **Step 4: Commit**

```bash
git add app/frontend
git commit -m "app: highlight-block link style in reading content"
```

---

### Task 4: Dark mode (graphite) with theme toggle

**Files:**
- Create: `app/frontend/packs/styles/base/_themes.scss`
- Create: `app/frontend/packs/controllers/theme_controller.js`
- Create: `spec/javascript/theme_controller_spec.js`
- Modify: `app/frontend/packs/styles/base/_colors.scss` (full rewrite)
- Modify: `app/frontend/packs/application.scss` (import themes first)
- Modify: `app/views/layouts/application.html.erb`, `app/views/layouts/admin_dashboard.html.erb` (head script)
- Create: `app/views/partials/_theme_script.html.erb`
- Modify: `app/views/partials/_navigation.html.erb` (toggle button)

**Interfaces:**
- Consumes: `$destructive`, `$button-shadow*`, `$link-highlight` tokens from Tasks 2–3 (if executing out of order, add them per those tasks first).
- Produces: every `colors.$x` SCSS variable resolves to `var(--x)`; `[data-theme='dark']` on `<html>` switches the palette. Light theme values are IDENTICAL to today's.

- [ ] **Step 1: Write the failing jest spec**

Create `spec/javascript/theme_controller_spec.js`:

```js
import { Application } from '@hotwired/stimulus'
import ThemeController from '../../app/frontend/packs/controllers/theme_controller'

describe('ThemeController', () => {
  beforeEach(() => {
    document.documentElement.removeAttribute('data-theme')
    localStorage.clear()
    document.body.innerHTML = "<button data-controller='theme' data-action='click->theme#toggle'>THEME</button>"
    window.matchMedia = jest.fn().mockReturnValue({ matches: false })
    const application = Application.start()
    application.register('theme', ThemeController)
  })

  it('switches to dark and persists', () => {
    document.querySelector('button').click()
    expect(document.documentElement.dataset.theme).toEqual('dark')
    expect(localStorage.getItem('theme')).toEqual('dark')
  })

  it('switches back to light on second toggle', () => {
    document.querySelector('button').click()
    document.querySelector('button').click()
    expect(document.documentElement.dataset.theme).toEqual('light')
    expect(localStorage.getItem('theme')).toEqual('light')
  })

  it('starts from the OS preference when unset', () => {
    window.matchMedia = jest.fn().mockReturnValue({ matches: true })
    document.querySelector('button').click()
    expect(document.documentElement.dataset.theme).toEqual('light')
  })
})
```

Match the async setup pattern used by `spec/javascript/nav_menu_controller_spec.js` if clicks don't register (Stimulus connects asynchronously — existing specs in this repo show the wait pattern; copy it).

- [ ] **Step 2: Run it to make sure it fails**

Run: `./tasks yarn test theme_controller`
Expected: FAIL — module not found.

- [ ] **Step 3: Implement the controller**

Create `app/frontend/packs/controllers/theme_controller.js`:

```js
import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  toggle () {
    const current = document.documentElement.dataset.theme ||
      (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light')
    const next = current === 'dark' ? 'light' : 'dark'
    document.documentElement.dataset.theme = next
    localStorage.setItem('theme', next)
  }
}
```

- [ ] **Step 4: Run the jest spec**

Run: `./tasks yarn test theme_controller`
Expected: PASS

- [ ] **Step 5: Create the theme token sheet**

Create `app/frontend/packs/styles/base/_themes.scss`:

```scss
@mixin dark-tokens {
  --color-dark: rgb(240, 240, 240);
  --color-light: rgb(24, 27, 32);
  --color-dark-dark: rgb(170, 175, 182);
  --color-medium-dark: rgb(140, 146, 154);
  --color-light-dark: rgb(110, 116, 124);
  --color-medium-light: rgb(58, 63, 70);
  --color-general-font: rgb(206, 210, 218);
  --color-darker-font: rgb(222, 226, 232);
  --color-heading-font: rgb(228, 231, 235);
  --color-inverse-font: rgb(240, 240, 240);
  --color-link: rgb(120, 170, 220);
  --color-alerts: rgb(255, 105, 97);
  --color-notices: rgb(120, 200, 120);
  --color-background: rgb(24, 27, 32);
  --color-background-dark: rgb(8, 8, 8);
  --color-box-border: rgb(60, 65, 72);
  --color-box-border-light: rgb(48, 53, 60);
  --color-box-highlight: rgb(48, 53, 60);
  --color-sidebar-background: rgb(34, 37, 42);
  --color-sidebar-highlight: rgb(15, 16, 19);
  --color-sidebar-text-unselected: rgb(151, 156, 172);
  --color-sidebar-text: rgb(211, 211, 211);
  --color-form-separator: rgb(90, 96, 104);
  --color-form-slider: rgb(58, 63, 70);
  --color-form-slider-thumb: rgb(76, 175, 80);
  --color-nav-button-hover: rgb(94, 94, 94);
  --color-theme: rgb(95, 175, 178);
  --color-destructive: rgb(224, 108, 100);
  --button-shadow: 0 1px 3px rgba(0, 0, 0, 0.5), 0 4px 16px rgba(0, 0, 0, 0.55);
  --button-shadow-hover: 0 2px 6px rgba(0, 0, 0, 0.5), 0 10px 26px rgba(0, 0, 0, 0.65);
  --link-highlight: rgba(95, 175, 178, 0.5);
}

:root {
  --color-dark: rgb(0, 0, 0);
  --color-light: rgb(255, 255, 255);
  --color-dark-dark: rgb(89, 89, 89);
  --color-medium-dark: rgb(110, 110, 110);
  --color-light-dark: rgb(150, 150, 150);
  --color-medium-light: rgb(211, 211, 211);
  --color-general-font: rgb(0, 0, 0);
  --color-darker-font: rgb(17, 23, 50);
  --color-heading-font: rgb(50, 55, 60);
  --color-inverse-font: rgb(240, 240, 240);
  --color-link: rgb(0, 69, 139);
  --color-alerts: rgb(255, 0, 0);
  --color-notices: rgb(0, 90, 0);
  --color-background: rgb(255, 255, 255);
  --color-background-dark: rgb(8, 8, 8);
  --color-box-border: rgb(204, 204, 204);
  --color-box-border-light: rgb(230, 230, 230);
  --color-box-highlight: rgb(230, 230, 230);
  --color-sidebar-background: rgb(34, 37, 42);
  --color-sidebar-highlight: rgb(15, 16, 19);
  --color-sidebar-text-unselected: rgb(151, 156, 172);
  --color-sidebar-text: rgb(211, 211, 211);
  --color-form-separator: rgb(160, 160, 160);
  --color-form-slider: rgb(211, 211, 211);
  --color-form-slider-thumb: rgb(76, 175, 80);
  --color-nav-button-hover: rgb(94, 94, 94);
  --color-theme: rgb(75, 149, 152);
  --color-destructive: rgb(160, 40, 40);
  --button-shadow: 0 1px 3px rgba(0, 0, 0, 0.1), 0 4px 14px rgba(0, 0, 0, 0.1);
  --button-shadow-hover: 0 2px 6px rgba(0, 0, 0, 0.1), 0 10px 24px rgba(0, 0, 0, 0.16);
  --link-highlight: rgba(75, 149, 152, 0.65);
}

[data-theme='dark'] {
  @include dark-tokens;
}

@media (prefers-color-scheme: dark) {
  :root:not([data-theme='light']) {
    @include dark-tokens;
  }
}
```

- [ ] **Step 6: Re-point `_colors.scss` at the tokens**

Replace the full contents of `app/frontend/packs/styles/base/_colors.scss` with (SCSS variable NAMES unchanged so all 67 existing usages compile):

```scss
// Values resolve at runtime via base/_themes.scss so the palette can switch
// per [data-theme] without touching component modules.
$dark: var(--color-dark);
$light: var(--color-light);
$dark-dark: var(--color-dark-dark);
$medium-dark: var(--color-medium-dark);
$light-dark: var(--color-light-dark);
$medium-light: var(--color-medium-light);

$general-font: var(--color-general-font);
$darker-font: var(--color-darker-font);
$heading-font: var(--color-heading-font);
$inverse-font: var(--color-inverse-font);
$link-color: var(--color-link);

$alerts: var(--color-alerts);
$notices: var(--color-notices);

$background-color: var(--color-background);
$background-dark: var(--color-background-dark);

$box-border-color: var(--color-box-border);
$box-border-light: var(--color-box-border-light);
$box-highlight: var(--color-box-highlight);

$sidebar-background: var(--color-sidebar-background);
$sidebar-highlight: var(--color-sidebar-highlight);
$sidebar-text-unselected: var(--color-sidebar-text-unselected);
$sidebar-text: var(--color-sidebar-text);

$form-separator: var(--color-form-separator);
$form-slider: var(--color-form-slider);
$form-slider-thumb: var(--color-form-slider-thumb);

$nav-button-hover: var(--color-nav-button-hover);

$theme-color: var(--color-theme);
$destructive: var(--color-destructive);
$button-shadow: var(--button-shadow);
$button-shadow-hover: var(--button-shadow-hover);
$link-highlight: var(--link-highlight);
```

Then in `app/frontend/packs/application.scss` add `@use 'styles/base/themes';` alongside the other base imports (order among `@use` lines doesn't matter for custom properties).

Watch for compile errors from SCSS colour functions being fed a `var()` — a pre-check found none in the codebase, but if the build fails on one, give that spot its own `--token` in `_themes.scss` instead.

- [ ] **Step 7: Pre-paint theme script + nav toggle**

Create `app/views/partials/_theme_script.html.erb`:

```erb
<script nonce="<%= content_security_policy_nonce %>">
  (function () {
    var theme = localStorage.getItem('theme')
    if (theme) { document.documentElement.dataset.theme = theme }
  })()
</script>
```

Render it as the FIRST element inside `<head>` in both `app/views/layouts/application.html.erb` and `app/views/layouts/admin_dashboard.html.erb`:

```erb
<%= render partial: 'partials/theme_script' %>
```

In `app/views/partials/_navigation.html.erb`, inside `<div class='lower'>` before the login/admin links, add:

```erb
        <button class='nav-item' data-controller='theme' data-action='click->theme#toggle' aria-label='Toggle dark mode'>
          DARK MODE
        </button>
```

- [ ] **Step 8: Full test + visual pass**

Run: `./tasks yarn test && ./tasks yarn lint && ./tasks rspec spec/feature`
Expected: PASS.

Visual: toggle on homepage, blog post, contact form, login, admin dashboard, admin forms. Light mode must look pixel-identical to before. Check flash messages, form borders, code snippets (syntax theme untouched — acceptable), buttons (primary inverts to light-on-graphite).

- [ ] **Step 9: Commit**

```bash
git add app/frontend app/views spec/javascript
git commit -m "app: graphite dark mode via css custom properties with theme toggle"
```

---

### Task 5: Admin gallery scroll load

**Files:**
- Create: `app/serializers/admin/gallery_image_serializer.rb`
- Modify: `app/frontend/packs/controllers/gallery_scroll_load_controller.js`
- Modify: `app/controllers/admin/gallery_images_controller.rb` (index)
- Modify: `app/views/admin/gallery_images/index.html.erb`
- Modify: `app/views/admin/images/_edit_image_form_entry.html.erb` (lazy attr)
- Test: `spec/requests/admin/gallery_images_request_spec.rb`, `spec/javascript/gallery_scroll_load_controller_spec.js`

**Interfaces:**
- Consumes: existing `GalleryImageSerializer` (attributes `title`, `description`, `thumbnail_url`, `url`), public pagination pattern in `app/controllers/gallery_images_controller.rb` (PAGE_SIZE/offset), Stimulus values API.
- Produces: `Admin::GalleryImageSerializer` adding `link_url`; scroll-load controller gains `linkAttribute` value (default `'url'`).

- [ ] **Step 1: Write the failing request spec**

Add to `spec/requests/admin/gallery_images_request_spec.rb` (create the describe block inside the existing logged-in admin context — copy the login helper usage from a neighbouring admin request spec in the same directory):

```ruby
describe 'GET /admin/gallery.json' do
  before do
    create_list(:gallery_image, 15)
  end

  it 'returns the first page of 12 with admin edit links' do
    get '/admin/gallery.json'
    data = JSON.parse(response.body)['data']
    expect(data.length).to eq(12)
    expect(data.first['attributes']['link_url']).to match(%r{/admin/gallery-images/\d+/edit})
    expect(data.first['attributes']['thumbnail_url']).to be_present
  end

  it 'returns the remainder for page 2' do
    get '/admin/gallery.json?page=2'
    expect(JSON.parse(response.body)['data'].length).to eq(3)
  end
end
```

If there is no `:gallery_image` factory with attached image, mirror how the public `spec/requests/gallery_images_request_spec.rb` sets up records and reuse that approach verbatim.

- [ ] **Step 2: Run it to verify failure**

Run: `./tasks rspec spec/requests/admin/gallery_images_request_spec.rb`
Expected: FAIL (JSON format not handled / `link_url` missing).

- [ ] **Step 3: Add the admin serializer**

Create `app/serializers/admin/gallery_image_serializer.rb`:

```ruby
module Admin
  class GalleryImageSerializer < ::GalleryImageSerializer
    attribute :link_url do |gallery_image|
      Rails.application.routes.url_helpers.edit_admin_gallery_image_path(gallery_image)
    end
  end
end
```

- [ ] **Step 4: Paginate the admin index**

In `app/controllers/admin/gallery_images_controller.rb` replace the `index` action with (mirrors `GalleryImagesController`):

```ruby
    PAGE_SIZE = 12

    def index
      @gallery_images = GalleryImage
                        .order(date_taken: :desc, id: :desc)
                        .includes(image_file_attachment: :blob)
                        .limit(PAGE_SIZE)
                        .offset(calc_offset)
      respond_to do |format|
        format.html { render layout: 'layouts/admin_dashboard' }
        format.json { render json: Admin::GalleryImageSerializer.new(@gallery_images, {}).serializable_hash }
      end
    end
```

and add to the controller's private section:

```ruby
    def calc_offset
      page_number = params['page'].to_i
      (page_number > 0) ? ((page_number - 1) * PAGE_SIZE) : 0
    end
```

- [ ] **Step 5: Run the request spec**

Run: `./tasks rspec spec/requests/admin/gallery_images_request_spec.rb`
Expected: PASS

- [ ] **Step 6: Add `linkAttribute` value to the scroll-load controller (jest first)**

Add to `spec/javascript/gallery_scroll_load_controller_spec.js` a test following the file's existing fetch-mock setup:

```js
it('links injected images via the configured link attribute', async () => {
  // configure the controller element with data-gallery-scroll-load-link-attribute-value='link_url'
  // and mock a fetch response whose attributes include link_url: '/admin/gallery-images/1/edit'
  // after loadNextPage resolves, expect the injected anchor href to end with '/admin/gallery-images/1/edit'
})
```

Fill the body by copying the file's existing "injects images" test and switching the asserted href source; this spec file already mocks `fetch` and the JSON:API payload shape.

Run: `./tasks yarn test gallery_scroll_load`
Expected: new test FAILS.

In `app/frontend/packs/controllers/gallery_scroll_load_controller.js` change:

```js
  static values = { page: Number, apiUrl: String, linkAttribute: { type: String, default: 'url' } }
```

and in `injectImages` change the anchor line to:

```js
        <a href='${imageData[this.linkAttributeValue]}' class='view-gallery-image'>
```

Run: `./tasks yarn test gallery_scroll_load`
Expected: PASS (including pre-existing tests — the default keeps the public behaviour).

- [ ] **Step 7: Wire up the admin index view**

Replace the `<ul>` block in `app/views/admin/gallery_images/index.html.erb` with:

```erb
    <ul class='gallery-container'
        data-controller='justified-gallery gallery-scroll-load'
        data-justified-gallery-target='container'
        data-justified-gallery-margin='2'
        data-gallery-scroll-load-page-value='1'
        data-gallery-scroll-load-api-url-value='<%= admin_gallery_images_path %>'
        data-gallery-scroll-load-link-attribute-value='link_url'
        data-action='renderGallery->justified-gallery#renderGallery galleryRendered->gallery-scroll-load#initializeScrollLoad'>
      <%= render partial: 'admin/gallery_images/image_container', collection: @gallery_images, as: :gallery_image %>
    </ul>
```

Compare with `app/views/gallery_images/index.html.erb:27-32` — same wiring minus the lightbox controller.

- [ ] **Step 8: Lazy-load the site-images page**

In `app/views/admin/images/_edit_image_form_entry.html.erb` add `loading: 'lazy'` to the `image_tag`:

```erb
    <%= image_tag(image_path_helper(image_model: image), class: 'embedded-full-width embedded-cover-image', loading: 'lazy') %>
```

- [ ] **Step 9: Full check + commit**

Run: `./tasks rspec spec/requests/admin && ./tasks yarn test && ./tasks rubocop`
Expected: PASS.

Visual: `http://localhost:3000/admin/gallery` — first 12 images render, scrolling to the bottom loads more, clicking a thumbnail opens its edit page.

```bash
git add app spec
git commit -m "app: scroll-load pagination for admin gallery and lazy site images"
```

---

### Task 6: Analytics dashboard

**Files:**
- Create: `app/services/analytics_service.rb`
- Create: `spec/services/analytics_service_spec.rb`
- Create: `spec/factories/visits.rb` (skip if a visit factory exists)
- Modify: `Gemfile`, `package.json` (via yarn), `app/frontend/packs/application.js.erb`
- Modify: `config/routes.rb` (named helpers), `app/controllers/admins_controller.rb`, `app/views/admins/analytics.html.erb`
- Modify: `app/frontend/packs/styles/components/_dashboard.scss` (small additions)
- Test: `spec/requests/admins_request_spec.rb`

**Interfaces:**
- Consumes: `Visit` model (`ahoy_visits`: `started_at`, `visitor_token`, `landing_page`, `referring_domain`, `country`, `city`, `device_type`, `browser`, `os`).
- Produces: `AnalyticsService.metrics(period)` returning a hash of chart-ready data; `admin_analytics_path` route helper.

- [ ] **Step 1: Install dependencies**

In `Gemfile`, after the ahoy block, add:

```ruby
# Admin analytics charts
gem 'chartkick', '~> 5.2'
gem 'groupdate', '~> 6.8'
```

Run: `./tasks bundle install && ./tasks yarn add chartkick@5.0.1 chart.js@4.5.1`

In `app/frontend/packs/application.js.erb` add below the Stimulus setup:

```js
import "chartkick/chart.js"
```

- [ ] **Step 2: Visit factory**

Create `spec/factories/visits.rb`:

```ruby
FactoryBot.define do
  factory :visit do
    sequence(:visit_token) { |n| "visit-token-#{n}" }
    sequence(:visitor_token) { |n| "visitor-token-#{n}" }
    started_at { Time.zone.now }
    landing_page { 'https://cpcwood.com/blog' }
    referring_domain { 'duckduckgo.com' }
    country { 'United Kingdom' }
    city { 'London' }
    device_type { 'Desktop' }
    browser { 'Firefox' }
    os { 'GNU/Linux' }
  end
end
```

- [ ] **Step 3: Write the failing service spec**

Create `spec/services/analytics_service_spec.rb`:

```ruby
require 'rails_helper'

RSpec.describe AnalyticsService do
  describe '.metrics' do
    before do
      create(:visit, started_at: 2.days.ago)
      create(:visit, started_at: 2.days.ago, visitor_token: 'repeat', country: 'France', city: 'Paris', device_type: 'Mobile')
      create(:visit, started_at: 2.days.ago, visitor_token: 'repeat')
      create(:visit, started_at: 60.days.ago)
    end

    it 'counts visits inside the period only' do
      expect(described_class.metrics('30d')[:visits_per_day].values.sum).to eq(3)
    end

    it 'counts unique visitors' do
      expect(described_class.metrics('30d')[:unique_visitors_per_day].values.sum).to eq(2)
    end

    it 'ranks countries' do
      expect(described_class.metrics('30d')[:top_countries].first(2)).to eq([['United Kingdom', 2], ['France', 1]])
    end

    it 'falls back to 30d for unknown periods' do
      expect(described_class.metrics('bogus')[:visits_per_day].values.sum).to eq(3)
    end

    it 'includes the other breakdowns' do
      metrics = described_class.metrics('90d')
      expect(metrics[:top_landing_pages].first.first).to eq('https://cpcwood.com/blog')
      expect(metrics[:top_referrers].first.first).to eq('duckduckgo.com')
      expect(metrics[:device_breakdown]).to include(['Desktop', 3], ['Mobile', 1])
      expect(metrics[:browser_breakdown].first.first).to eq('Firefox')
      expect(metrics[:os_breakdown].first.first).to eq('GNU/Linux')
      expect(metrics[:top_cities].first.first).to eq('London')
    end
  end
end
```

- [ ] **Step 4: Run it to verify failure**

Run: `./tasks rspec spec/services/analytics_service_spec.rb`
Expected: FAIL — `AnalyticsService` not defined.

- [ ] **Step 5: Implement the service**

Create `app/services/analytics_service.rb`:

```ruby
module AnalyticsService
  PERIODS = {
    '7d' => 7.days,
    '30d' => 30.days,
    '90d' => 90.days,
    '12m' => 12.months
  }.freeze
  DEFAULT_PERIOD = '30d'.freeze
  TOP_LIMIT = 10

  class << self
    def metrics(period)
      scope = Visit.where(started_at: PERIODS.fetch(period, PERIODS[DEFAULT_PERIOD]).ago..)
      {
        visits_per_day: scope.group_by_day(:started_at).count,
        unique_visitors_per_day: scope.group_by_day(:started_at).distinct.count(:visitor_token),
        top_landing_pages: top(scope, :landing_page),
        top_referrers: top(scope, :referring_domain),
        top_countries: top(scope, :country),
        top_cities: top(scope, :city),
        device_breakdown: scope.group(:device_type).count.sort_by { |_, count| -count },
        browser_breakdown: scope.group(:browser).count.sort_by { |_, count| -count },
        os_breakdown: scope.group(:os).count.sort_by { |_, count| -count }
      }
    end

    private

    def top(scope, column)
      scope.where.not(column => [nil, '']).group(column).order(count_all: :desc).limit(TOP_LIMIT).count.to_a
    end
  end
end
```

- [ ] **Step 6: Run the service spec**

Run: `./tasks rspec spec/services/analytics_service_spec.rb`
Expected: PASS

- [ ] **Step 7: Controller + named routes**

In `config/routes.rb` name the admin dashboard routes:

```ruby
  get '/admin', to: 'admins#general'
  get '/admin/notifications', to: 'admins#notifications', as: :admin_notifications
  get '/admin/analytics', to: 'admins#analytics', as: :admin_analytics
```

In `app/controllers/admins_controller.rb` replace the `analytics` action:

```ruby
  def analytics
    @period = params[:period].presence_in(AnalyticsService::PERIODS.keys) || AnalyticsService::DEFAULT_PERIOD
    @metrics = AnalyticsService.metrics(@period)
    render_dashboard
  end
```

- [ ] **Step 8: Build the view**

Replace `app/views/admins/analytics.html.erb` with:

```erb
<% content_for :section_subtitle do %>
  Analytics
<% end %>

<div class='dashboard-item-container'>
  <div class='analytics-period-selector'>
    <% AnalyticsService::PERIODS.each_key do |key| %>
      <%= link_to(key.upcase, admin_analytics_path(period: key), class: "standard-button #{key == @period ? '' : 'secondary'}") %>
    <% end %>
  </div>
</div>
<div class='dashboard-item-separator'></div>

<div class='dashboard-item-container'>
  <h3>Visits</h3>
  <%= line_chart([
        { name: 'Visits', data: @metrics[:visits_per_day] },
        { name: 'Unique visitors', data: @metrics[:unique_visitors_per_day] }
      ], colors: ['#4b9598', '#6e6e6e']) %>
</div>
<div class='dashboard-item-separator'></div>

<div class='dashboard-item-container'>
  <h3>Locations</h3>
  <div class='analytics-columns'>
    <div>
      <h4>Countries</h4>
      <%= render partial: 'admins/analytics_table', locals: { rows: @metrics[:top_countries] } %>
    </div>
    <div>
      <h4>Cities</h4>
      <%= render partial: 'admins/analytics_table', locals: { rows: @metrics[:top_cities] } %>
    </div>
  </div>
</div>
<div class='dashboard-item-separator'></div>

<div class='dashboard-item-container'>
  <h3>Pages &amp; Referrers</h3>
  <div class='analytics-columns'>
    <div>
      <h4>Top landing pages</h4>
      <%= render partial: 'admins/analytics_table', locals: { rows: @metrics[:top_landing_pages] } %>
    </div>
    <div>
      <h4>Top referrers</h4>
      <%= render partial: 'admins/analytics_table', locals: { rows: @metrics[:top_referrers] } %>
    </div>
  </div>
</div>
<div class='dashboard-item-separator'></div>

<div class='dashboard-item-container'>
  <h3>Technology</h3>
  <div class='analytics-columns'>
    <div>
      <h4>Devices</h4>
      <%= pie_chart @metrics[:device_breakdown], donut: true %>
    </div>
    <div>
      <h4>Browsers</h4>
      <%= pie_chart @metrics[:browser_breakdown], donut: true %>
    </div>
    <div>
      <h4>Operating systems</h4>
      <%= pie_chart @metrics[:os_breakdown], donut: true %>
    </div>
  </div>
</div>
```

Create `app/views/admins/_analytics_table.html.erb`:

```erb
<table class='analytics-table'>
  <% rows.each do |label, count| %>
    <tr>
      <td class='analytics-table-label'><%= label %></td>
      <td class='analytics-table-count'><%= count %></td>
    </tr>
  <% end %>
  <% if rows.empty? %>
    <tr><td>No data for this period</td></tr>
  <% end %>
</table>
```

Append to `app/frontend/packs/styles/components/_dashboard.scss`:

```scss
.analytics-period-selector {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.analytics-columns {
  display: grid;
  gap: 20px;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
}

.analytics-table {
  border-collapse: collapse;
  width: 100%;

  td {
    border-bottom: 1px solid colors.$box-border-light;
    padding: 6px 4px;
  }

  .analytics-table-label {
    overflow-wrap: anywhere;
  }

  .analytics-table-count {
    text-align: right;
    white-space: nowrap;
  }
}
```

(Confirm `_dashboard.scss` already has `@use '../base/colors';` — add it if missing.)

- [ ] **Step 9: Request spec**

In `spec/requests/admins_request_spec.rb`, extend the existing analytics examples (or add if absent), inside the logged-in context used by the other admin page specs:

```ruby
describe 'GET /admin/analytics' do
  before { create(:visit, started_at: 1.day.ago) }

  it 'renders the dashboard with metrics' do
    get '/admin/analytics'
    expect(response).to have_http_status(:ok)
    expect(response.body).to include('Unique visitors')
    expect(response.body).to include('United Kingdom')
  end

  it 'accepts a period param' do
    get '/admin/analytics?period=7d'
    expect(response).to have_http_status(:ok)
  end
end
```

Run: `./tasks rspec spec/requests/admins_request_spec.rb`
Expected: PASS

- [ ] **Step 10: Full check + commit**

Run: `./tasks rspec && ./tasks rubocop && ./tasks yarn lint`
Expected: PASS. Visual: `/admin/analytics` renders charts; period buttons switch ranges.

```bash
git add Gemfile Gemfile.lock package.json yarn.lock app config spec
git commit -m "app: ahoy analytics dashboard with period filter"
```

---

### Task 7: Contact messages in admin notifications

**Files:**
- Modify: `app/controllers/admins_controller.rb`
- Modify: `app/views/admins/notifications.html.erb`
- Test: `spec/requests/admins_request_spec.rb`

**Interfaces:**
- Consumes: `ContactMessage` (`from`, `email`, `subject`, `content`, `created_at`), `DateHelper#full_date_and_time` (used by mailers — confirm it's available to views via `app/helpers/date_helper.rb`), named route `admin_notifications_path` from Task 6 Step 7 (add the `as:` yourself if Task 6 hasn't run).

- [ ] **Step 1: Write the failing request spec**

Add to `spec/requests/admins_request_spec.rb` in the logged-in context:

```ruby
describe 'GET /admin/notifications' do
  before do
    create_list(:contact_message, 26, user: User.first)
    ContactMessage.first.update(subject: 'Oldest message subject')
  end

  it 'lists the newest 25 contact messages' do
    get '/admin/notifications'
    expect(response).to have_http_status(:ok)
    expect(response.body).not_to include('Oldest message subject')
  end

  it 'pages older messages' do
    get '/admin/notifications?page=2'
    expect(response.body).to include('Oldest message subject')
  end
end
```

If there's no `:contact_message` factory, create `spec/factories/contact_messages.rb`:

```ruby
FactoryBot.define do
  factory :contact_message do
    from { 'Jane Doe' }
    sequence(:email) { |n| "jane#{n}@example.com" }
    sequence(:subject) { |n| "Subject #{n}" }
    content { 'Hello there' }
    user
  end
end
```

(`ContactMessage#send_contact_message` enqueues a job `after_commit` — the test adapter only enqueues, so creation in specs is safe.)

- [ ] **Step 2: Run to verify failure**

Run: `./tasks rspec spec/requests/admins_request_spec.rb`
Expected: FAIL (page shows "Placeholder", not messages).

- [ ] **Step 3: Implement controller + view**

In `app/controllers/admins_controller.rb`:

```ruby
  MESSAGES_PAGE_SIZE = 25

  def notifications
    @page = [params[:page].to_i, 1].max
    @contact_messages = ContactMessage
                        .order(created_at: :desc)
                        .limit(MESSAGES_PAGE_SIZE)
                        .offset((@page - 1) * MESSAGES_PAGE_SIZE)
    @more_pages = ContactMessage.count > @page * MESSAGES_PAGE_SIZE
    render_dashboard
  end
```

Replace `app/views/admins/notifications.html.erb` with:

```erb
<% content_for :section_subtitle do %>
  Notifications
<% end %>

<div class='dashboard-item-container'>
  <h3>
    Contact Messages
  </h3>
  <% if @contact_messages.empty? %>
    <%= render partial: 'partials/no_items', locals: { item: 'contact messages' } %>
  <% end %>
</div>

<% @contact_messages.each do |message| %>
  <div class='dashboard-item-container contact-message'>
    <h4><%= message.subject %></h4>
    <div class='small-font'>
      From <%= message.from %> &lt;<%= message.email %>&gt; — <%= full_date_and_time(message.created_at) %>
    </div>
    <p><%= message.content %></p>
  </div>
  <div class='dashboard-item-separator'></div>
<% end %>

<div class='dashboard-item-container'>
  <% if @page > 1 %>
    <%= link_to('Newer', admin_notifications_path(page: @page - 1), class: 'standard-button secondary') %>
  <% end %>
  <% if @more_pages %>
    <%= link_to('Older', admin_notifications_path(page: @page + 1), class: 'standard-button secondary') %>
  <% end %>
</div>
```

If `full_date_and_time` isn't exposed as a view helper (it lives in `DateHelper`), include the module: check `app/helpers/date_helper.rb` exists — helpers in `app/helpers` are auto-included in views.

- [ ] **Step 4: Run the spec**

Run: `./tasks rspec spec/requests/admins_request_spec.rb`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add app spec
git commit -m "app: list contact messages on admin notifications page"
```

---

### Task 8: TOTP 2FA (replace Twilio SMS)

**Files:**
- Create: migration `add_totp_to_users`, migration `remove_mobile_number_from_users`
- Create: `app/controllers/admin/two_factor_auths_controller.rb`, `app/views/admin/two_factor_auths/new.html.erb`
- Create: `spec/requests/admin/two_factor_auths_request_spec.rb`
- Modify: `Gemfile`, `config/application.rb`, `config/routes.rb`, `config/env/.env.template`, `config/env/test-defaults.env`, `db/seeds.rb`, `README.md`
- Modify: `app/models/user.rb`, `app/services/two_factor_auth_service.rb`, `app/controllers/sessions_controller.rb`, `app/views/sessions/two_factor_auth.html.erb`, `app/views/admin/users/edit.html.erb`, `app/views/admin/users/_edit_form.html.erb`, `app/controllers/admin/users_controller.rb`, `app/views/admins/general.html.erb`
- Modify: `scripts/populate-parameter-store.sh`, `infrastructure/terraform/secrets.tf` (description only)
- Test: `spec/models/user_spec.rb`, `spec/services/two_factor_auth_service_spec.rb`, `spec/requests/sessions_request_spec.rb`, `spec/requests/admin/users_request_spec.rb`, `spec/factories/users.rb`, `spec/feature/admin_update_details_spec.rb`, `spec/views/admin/users/edit.html.erb_spec.rb`

**Interfaces:**
- Produces: `User#otp_enabled?`, `User#verify_totp!(code) -> bool`, `User#otp_provisioning_uri`, `User.pending_otp_secret` generation via `ROTP::Base32.random`. `TwoFactorAuthService.start/started?/get_user/auth_code_format_valid?/auth_code_valid?` keep their signatures (verification backend swapped).
- Env: `AR_ENCRYPTION_PRIMARY_KEY`, `AR_ENCRYPTION_DETERMINISTIC_KEY`, `AR_ENCRYPTION_KEY_DERIVATION_SALT` required in every environment.

- [ ] **Step 1: Swap gems**

In `Gemfile` remove:

```ruby
# Verify 2FA using twilio
gem 'twilio-ruby', '~> 7.10', require: false
```

and add in its place:

```ruby
# TOTP two factor auth
gem 'rotp', '~> 6.3'
gem 'rqrcode', '~> 3.2'
```

Run: `./tasks bundle install`

- [ ] **Step 2: Active Record encryption keys**

In `config/application.rb`, replace the twilio config block (lines 50-53) with:

```ruby
    # active record encryption
    config.active_record.encryption.primary_key = ENV['AR_ENCRYPTION_PRIMARY_KEY']
    config.active_record.encryption.deterministic_key = ENV['AR_ENCRYPTION_DETERMINISTIC_KEY']
    config.active_record.encryption.key_derivation_salt = ENV['AR_ENCRYPTION_KEY_DERIVATION_SALT']
```

In `config/env/test-defaults.env` remove the `TWILIO_*` and `ADMIN_MOBILE_NUMBER` lines and add:

```
AR_ENCRYPTION_PRIMARY_KEY=test-primary-key-test-primary-key
AR_ENCRYPTION_DETERMINISTIC_KEY=test-deterministic-key-test-key
AR_ENCRYPTION_KEY_DERIVATION_SALT=test-key-derivation-salt-test
```

In `config/env/.env.template` remove the `# Twilio Credentials` block and `ADMIN_MOBILE_NUMBER`, and add under a new heading:

```
# Active Record Encryption (generate with: rails db:encryption:init)
AR_ENCRYPTION_PRIMARY_KEY=<ar-encryption-primary-key>
AR_ENCRYPTION_DETERMINISTIC_KEY=<ar-encryption-deterministic-key>
AR_ENCRYPTION_KEY_DERIVATION_SALT=<ar-encryption-key-derivation-salt>
```

Add the same three values to your local `config/env/.env` (generate real ones with `./tasks rails db:encryption:init`).

- [ ] **Step 3: Migrations**

Run: `./tasks rails generate migration AddTotpToUsers otp_secret:text otp_consumed_timestep:integer`
Run: `./tasks rails generate migration RemoveMobileNumberFromUsers`

Edit the second migration:

```ruby
class RemoveMobileNumberFromUsers < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :mobile_number, :text
  end
end
```

Run: `./tasks rails db:migrate && ./tasks rails db:migrate RAILS_ENV=test`
Expected: both succeed; `db/schema.rb` updated; annotations refresh on next annotate run.

- [ ] **Step 4: Failing model spec**

In `spec/models/user_spec.rb` delete the mobile-number validation examples and add:

```ruby
describe 'totp' do
  subject(:user) { create(:user, :with_totp) }

  let(:totp) { ROTP::TOTP.new(user.otp_secret) }

  describe '#otp_enabled?' do
    it 'is true with a secret' do
      expect(user.otp_enabled?).to eq(true)
    end

    it 'is false without a secret' do
      expect(create(:user).otp_enabled?).to eq(false)
    end
  end

  describe '#verify_totp!' do
    it 'accepts the current code once' do
      code = totp.now
      expect(user.verify_totp!(code)).to eq(true)
      expect(user.verify_totp!(code)).to eq(false)
    end

    it 'rejects a wrong code' do
      expect(user.verify_totp!('000000')).to eq(false)
    end

    it 'is false when no secret is set' do
      expect(create(:user).verify_totp!('123456')).to eq(false)
    end
  end

  describe '#otp_provisioning_uri' do
    it 'embeds the user email' do
      expect(user.otp_provisioning_uri).to include(CGI.escape(user.email))
    end
  end
end
```

In `spec/factories/users.rb` remove `mobile_number` attributes and add the trait:

```ruby
    trait :with_totp do
      otp_secret { ROTP::Base32.random }
    end
```

Run: `./tasks rspec spec/models/user_spec.rb`
Expected: FAIL — methods missing.

- [ ] **Step 5: Update the User model**

In `app/models/user.rb`:
- Delete the `mobile_number` validation block, `convert_mobile_number` method and its `after_validation` callback.
- Add below `has_secure_password`:

```ruby
  encrypts :otp_secret

  def otp_enabled?
    otp_secret.present?
  end

  def verify_totp!(code)
    return false unless otp_enabled?
    timestamp = totp.verify(code, drift_behind: 15, after: otp_consumed_timestep)
    return false unless timestamp
    update(otp_consumed_timestep: timestamp)
    true
  end

  def otp_provisioning_uri
    totp.provisioning_uri(email)
  end

  private

  def totp
    ROTP::TOTP.new(otp_secret, issuer: ENV.fetch('SITE_HOST', 'home-server'))
  end
```

(Place the private methods with the existing private section.)

Run: `./tasks rspec spec/models/user_spec.rb`
Expected: PASS

- [ ] **Step 6: Rewrite TwoFactorAuthService (spec first)**

Replace `spec/services/two_factor_auth_service_spec.rb` contents with:

```ruby
require 'rails_helper'

RSpec.describe TwoFactorAuthService do
  subject(:service) { described_class }

  let(:user) { create(:user, :with_totp) }
  let(:session) { {} }

  describe '.start / .started? / .get_user' do
    it 'stores and retrieves the pending user' do
      service.start(session, user)
      expect(service.started?(session)).to eq(true)
      expect(service.get_user(session)).to eq(user)
    end

    it 'is not started for an empty session' do
      expect(service.started?(session)).to eq(false)
    end
  end

  describe '.auth_code_format_valid?' do
    it 'accepts six digits' do
      expect(service.auth_code_format_valid?('123456')).to eq(true)
    end

    it 'rejects other formats' do
      expect(service.auth_code_format_valid?('12345a')).to eq(false)
    end
  end

  describe '.auth_code_valid?' do
    before { service.start(session, user) }

    it 'is true for the current totp code' do
      code = ROTP::TOTP.new(user.otp_secret).now
      expect(service.auth_code_valid?(session: session, auth_code: code)).to eq(true)
    end

    it 'is false for a wrong code' do
      expect(service.auth_code_valid?(session: session, auth_code: '000000')).to eq(false)
    end
  end
end
```

Run: `./tasks rspec spec/services/two_factor_auth_service_spec.rb` — FAIL, then replace `app/services/two_factor_auth_service.rb` with:

```ruby
module TwoFactorAuthService
  class << self
    def start(session, user)
      session[:two_factor_auth_id] = user.id
      true
    end

    def started?(session)
      !!session[:two_factor_auth_id]
    end

    def auth_code_format_valid?(auth_code)
      auth_code.match?(/^\d{6}$/)
    end

    def auth_code_valid?(session:, auth_code:)
      !!get_user(session)&.verify_totp!(auth_code)
    end

    def get_user(session)
      User.find_by(id: session[:two_factor_auth_id])
    end
  end
end
```

Run again: PASS.

- [ ] **Step 7: Sessions controller + routes + view**

In `config/routes.rb` replace the 2fa routes:

```ruby
  get '/2fa', to: 'sessions#show_2fa'
  post '/2fa', to: 'sessions#verify_2fa'
```

(the `put '/2fa'` resend route is deleted).

In `app/controllers/sessions_controller.rb`:
- Replace `send_2fa` with:

```ruby
  def show_2fa
    return redirect_to(:login) unless TwoFactorAuthService.started?(session)
    flash.now[:notice] = 'Enter the 6 digit code from your authenticator app' unless flash[:notice]
    render(:two_factor_auth)
  end
```

- Delete `reset_2fa`.
- In `new`, replace `return log_user_in if Rails.env.development?` with:

```ruby
    return log_user_in if Rails.env.development? || !@user.otp_enabled?
```

- In `log_user_in`, extend the notice so an unenrolled user is nudged:

```ruby
  def log_user_in
    @user = TwoFactorAuthService.get_user(session)
    reset_session
    session[:user_id] = @user.id
    @user.record_ip(request)
    notice = "#{@user.username} welcome back to your home-server!"
    notice += ' Two factor authentication is not set up — enable it in User Settings.' unless @user.otp_enabled?
    redirect_to(:admin, notice: notice)
  end
```

In `app/views/sessions/two_factor_auth.html.erb` delete the resend form block:

```erb
    <%= form_tag('/2fa', method: :put) do %>
      <%= submit_tag("Resend 2fa code", class: 'option left') %>
    <% end %>
```

(keep the Cancel Login form).

- [ ] **Step 8: Enrollment controller (spec first)**

Create `spec/requests/admin/two_factor_auths_request_spec.rb` (copy the admin login helper from a neighbouring spec in `spec/requests/admin/`):

```ruby
require 'rails_helper'

RSpec.describe 'Admin::TwoFactorAuths', type: :request do
  # use the repo's standard logged-in admin setup here

  describe 'GET /admin/2fa-setup/new' do
    it 'shows a qr code and manual key' do
      get '/admin/2fa-setup/new'
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('svg')
      expect(response.body).to include('Manual key')
    end
  end

  describe 'POST /admin/2fa-setup' do
    it 'activates totp with a valid code' do
      get '/admin/2fa-setup/new'
      pending_secret = session[:pending_otp_secret]
      post '/admin/2fa-setup', params: { auth_code: ROTP::TOTP.new(pending_secret).now }
      expect(User.first.reload.otp_enabled?).to eq(true)
    end

    it 'rejects an invalid code' do
      get '/admin/2fa-setup/new'
      post '/admin/2fa-setup', params: { auth_code: '000000' }
      expect(User.first.reload.otp_enabled?).to eq(false)
    end
  end
end
```

Run: FAIL. Then add to `config/routes.rb` inside `namespace :admin`:

```ruby
    resource :two_factor_auth, only: [:new, :create], path: '/2fa-setup'
```

Create `app/controllers/admin/two_factor_auths_controller.rb`:

```ruby
module Admin
  class TwoFactorAuthsController < AdminBaseController
    def new
      session[:pending_otp_secret] ||= ROTP::Base32.random
      @pending_otp_secret = session[:pending_otp_secret]
      provisioning_uri = ROTP::TOTP.new(@pending_otp_secret, issuer: ENV.fetch('SITE_HOST', 'home-server')).provisioning_uri(@user.email)
      @qr_code_svg = RQRCode::QRCode.new(provisioning_uri).as_svg(module_size: 4, viewbox: true)
      render layout: 'layouts/admin_dashboard'
    end

    def create
      pending_secret = session[:pending_otp_secret]
      return redirect_to(new_admin_two_factor_auth_path, alert: 'Two factor setup expired, scan again') unless pending_secret
      auth_code = params[:auth_code].to_s
      timestamp = ROTP::TOTP.new(pending_secret).verify(auth_code, drift_behind: 15)
      return redirect_to(new_admin_two_factor_auth_path, alert: 'Code incorrect, please try again') unless timestamp
      @user.update(otp_secret: pending_secret, otp_consumed_timestep: timestamp)
      session.delete(:pending_otp_secret)
      redirect_to(edit_admin_user_path(@user), notice: 'Two factor authentication enabled!')
    end
  end
end
```

(Check `AdminBaseController` assigns `@user` and enforces login — it's the base for every admin controller.)

Create `app/views/admin/two_factor_auths/new.html.erb`:

```erb
<% content_for :section_subtitle do %>
  Two Factor Authentication Setup
<% end %>

<%= render partial: 'partials/system_messages' %>

<div class='dashboard-item-container'>
  <h3>Scan with your authenticator app</h3>
  <div class='two-factor-qr'>
    <%= @qr_code_svg.html_safe %>
  </div>
  <div class='small-font'>
    Manual key: <code><%= @pending_otp_secret %></code>
  </div>
</div>
<div class='dashboard-item-separator'></div>
<div class='dashboard-item-container'>
  <%= form_with(url: admin_two_factor_auth_path, method: :post) do |f| %>
    <%= f.text_field(:auth_code, required: true, autocomplete: 'one-time-code', class: 'input-box', placeholder: '6 digit code') %>
    <div class='input-seperator'></div>
    <%= f.submit('Confirm and enable', class: 'input-submit') %>
  <% end %>
</div>
```

Add a size cap for the QR svg to `app/frontend/packs/styles/components/_dashboard.scss`:

```scss
.two-factor-qr {
  margin: 10px 0;
  max-width: 240px;

  svg {
    height: auto;
    width: 100%;
  }
}
```

Run: `./tasks rspec spec/requests/admin/two_factor_auths_request_spec.rb`
Expected: PASS

- [ ] **Step 9: Surface enrollment state**

In `app/views/admin/users/edit.html.erb` add before the final container:

```erb
<div class='dashboard-item-separator'></div>
<div class='dashboard-item-container'>
  <h3>Two Factor Authentication</h3>
  <% if @user.otp_enabled? %>
    <p>Enabled — codes come from your authenticator app.</p>
    <%= link_to('Re-enroll a new device', new_admin_two_factor_auth_path, class: 'standard-button secondary') %>
  <% else %>
    <p>Not enabled.</p>
    <%= link_to('Set up 2FA', new_admin_two_factor_auth_path, class: 'standard-button') %>
  <% end %>
</div>
```

In `app/views/admins/general.html.erb` add at the top (after any `content_for` block):

```erb
<% unless @user.otp_enabled? %>
  <div class='dashboard-item-container'>
    <strong>Two factor authentication is not enabled.</strong>
    <%= link_to('Set it up now', new_admin_two_factor_auth_path) %>
  </div>
  <div class='dashboard-item-separator'></div>
<% end %>
```

- [ ] **Step 10: Purge mobile number from admin user editing**

In `app/controllers/admin/users_controller.rb` delete the line `update_section(mobile_number_update_params, 'Mobile number')` and the `mobile_number_update_params` method.

In `app/views/admin/users/_edit_form.html.erb` delete the mobile number form section (the block referencing `mobile_number` / `mobile_number_confirmation`).

In `db/seeds.rb` delete the `mobile_number: ENV['ADMIN_MOBILE_NUMBER'])` argument (close the paren on the previous line).

Grep for stragglers: `grep -rn "mobile_number\|twilio\|Twilio\|TWILIO" app config db spec README.md` — fix every hit: delete mobile-number assertions/inputs in `spec/feature/admin_update_details_spec.rb`, `spec/requests/admin/users_request_spec.rb`, `spec/views/admin/users/edit.html.erb_spec.rb`; update `spec/requests/sessions_request_spec.rb` to the new flow:

```ruby
# enrolled user: expect redirect to /2fa after POST /login, then
post '/2fa', params: { auth_code: ROTP::TOTP.new(user.otp_secret).now }
# expect session to be logged in / redirect to /admin

# unenrolled user: POST /login logs straight in with the enrollment notice
```

Rewrite the relevant examples fully — mock nothing; generate real codes with ROTP. Delete any WebMock stubs of the Twilio API.

- [ ] **Step 11: Update README + populate script + secrets description**

`README.md`: replace the "Twilio SMS Verification" bullet with "TOTP two factor authentication (authenticator app)". Add a "2FA reset" note under a suitable admin/setup section:

```markdown
#### 2FA reset

If the authenticator device is lost, clear the secret from a Rails console and re-enroll:
​```ruby
User.first.update(otp_secret: nil, otp_consumed_timestep: nil)
​```
```

`scripts/populate-parameter-store.sh`: in the `keys=(...)` array remove `ADMIN_MOBILE_NUMBER`, `TWILIO_ACCOUNT_SID`, `TWILIO_AUTH_TOKEN`, `TWILIO_VERIFY_SERVICE_SID` and add `AR_ENCRYPTION_PRIMARY_KEY AR_ENCRYPTION_DETERMINISTIC_KEY AR_ENCRYPTION_KEY_DERIVATION_SALT` (keep the array sorted).

`infrastructure/terraform/secrets.tf`: update the `app` parameter description from `(SECRET_KEY_BASE, SMTP, Twilio, Sentry, reCAPTCHA)` to `(SECRET_KEY_BASE, SMTP, Sentry, reCAPTCHA, AR encryption)`.

- [ ] **Step 12: Full suite + commit**

Run: `./tasks rspec && ./tasks rubocop`
Expected: PASS — zero remaining twilio/mobile references (`grep -rn "twilio" app config spec Gemfile` returns nothing).

Manual: log in locally (dev skips 2FA), visit `/admin/2fa-setup/new`, scan with an authenticator, confirm; log out; in a production-like env the login would now demand the code.

```bash
git add -A
git commit -m "app: replace twilio sms 2fa with totp authenticator enrollment"
```

**Deploy note (include in PR description):** after deploy, log in (no 2FA prompt — not yet enrolled), immediately visit User Settings → Set up 2FA. New SSM keys `AR_ENCRYPTION_*` must be populated via `scripts/populate-parameter-store.sh app` BEFORE deploying.

---

### Task 9: SES-backed SMTP via Terraform

**Files:**
- Create: `infrastructure/terraform/ses.tf`
- Modify: `infrastructure/terraform/variables.tf`, `infrastructure/terraform/outputs.tf`, `infrastructure/terraform/ci.tf` (CI role perms)
- Modify: `infrastructure/helm/charts/app/values.yaml`, `infrastructure/helm/charts/app/templates/externalsecret.yaml`
- Modify: `infrastructure/helm/charts/worker/values.yaml`, `infrastructure/helm/charts/worker/templates/externalsecret.yaml`
- Modify: umbrella values if `externalSecrets.*Bundle` keys live there (check `infrastructure/helm/values.yaml`)
- Modify: `scripts/populate-parameter-store.sh`, `README.md`

**Interfaces:**
- Consumes: `local.secret_prefix` from `secrets.tf`, existing `externalSecrets` values structure (`appBundle`, `dbBundle`, `storageBundle` — mirror for `emailBundle`).
- Produces: SSM parameter `/<cluster>/home-server/<env>/email` (Terraform-owned) containing `EMAIL_SMTP_USERNAME`/`EMAIL_SMTP_PASSWORD`; DKIM/verification outputs for manual DNS.

- [ ] **Step 1: Terraform SES resources**

Create `infrastructure/terraform/ses.tf`:

```hcl
resource "aws_ses_domain_identity" "email" {
  domain = var.email_domain
}

resource "aws_ses_domain_dkim" "email" {
  domain = aws_ses_domain_identity.email.domain
}

data "aws_iam_policy_document" "ses_send" {
  statement {
    effect    = "Allow"
    actions   = ["ses:SendRawEmail", "ses:SendEmail"]
    resources = [aws_ses_domain_identity.email.arn]
  }
}

resource "aws_iam_user" "ses_smtp" {
  name = "home-server-${var.environment}-ses-smtp"
}

resource "aws_iam_user_policy" "ses_smtp" {
  name   = "ses-send"
  user   = aws_iam_user.ses_smtp.name
  policy = data.aws_iam_policy_document.ses_send.json
}

resource "aws_iam_access_key" "ses_smtp" {
  user = aws_iam_user.ses_smtp.name
}

resource "aws_ssm_parameter" "email" {
  name        = "${local.secret_prefix}/email"
  description = "SES SMTP credentials (generated by Terraform)"
  type        = "SecureString"
  value = jsonencode({
    EMAIL_SMTP_USERNAME = aws_iam_access_key.ses_smtp.id
    EMAIL_SMTP_PASSWORD = aws_iam_access_key.ses_smtp.ses_smtp_password_v4
  })
}
```

Add to `infrastructure/terraform/variables.tf`:

```hcl
variable "email_domain" {
  description = "Domain SES sends mail from"
  type        = string
  default     = "cpcwood.com"
}
```

Add to `infrastructure/terraform/outputs.tf`:

```hcl
output "ses_domain_verification_token" {
  description = "TXT record value for _amazonses.<domain> — add manually at the DNS host"
  value       = aws_ses_domain_identity.email.verification_token
}

output "ses_dkim_tokens" {
  description = "Three CNAMEs: <token>._domainkey.<domain> -> <token>.dkim.amazonses.com"
  value       = aws_ses_domain_dkim.email.dkim_tokens
}
```

- [ ] **Step 2: CI role permissions**

In `infrastructure/terraform/ci.tf` (or wherever `data.aws_iam_policy_document.github_actions_permissions` statements live — it may be `iam.tf`), add a statement so CI applies can manage these resources:

```hcl
  statement {
    sid    = "SesManagement"
    effect = "Allow"
    actions = [
      "ses:VerifyDomainIdentity",
      "ses:VerifyDomainDkim",
      "ses:DeleteIdentity",
      "ses:GetIdentityVerificationAttributes",
      "ses:GetIdentityDkimAttributes",
      "ses:ListIdentities",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "SesSmtpUser"
    effect = "Allow"
    actions = [
      "iam:CreateUser",
      "iam:DeleteUser",
      "iam:GetUser",
      "iam:TagUser",
      "iam:PutUserPolicy",
      "iam:GetUserPolicy",
      "iam:DeleteUserPolicy",
      "iam:ListUserPolicies",
      "iam:ListAttachedUserPolicies",
      "iam:CreateAccessKey",
      "iam:DeleteAccessKey",
      "iam:ListAccessKeys",
      "iam:ListGroupsForUser",
    ]
    resources = ["arn:aws:iam::*:user/home-server-*-ses-smtp"]
  }
```

(SES identity actions don't support resource-level scoping — `*` is required. Match the surrounding statements' formatting. If existing `ssm:PutParameter` permissions are scoped to the `home-server` prefix, the new `/email` parameter is already covered — verify by reading the existing SSM statement.)

- [ ] **Step 3: Helm — point SMTP at SES and re-key credentials**

In BOTH `infrastructure/helm/charts/app/values.yaml` and `infrastructure/helm/charts/worker/values.yaml` change:

```yaml
  EMAIL_SMTP_SERVER_ADDRESS: "email-smtp.eu-west-2.amazonaws.com"
  EMAIL_SMTP_SERVER_PORT: "465"
```

In both charts' `externalsecret.yaml`, append to the `data:` list:

```yaml
    - secretKey: EMAIL_SMTP_USERNAME
      remoteRef:
        key: {{ .Values.global.secretPrefix }}/{{ .Values.externalSecrets.emailBundle }}
        property: EMAIL_SMTP_USERNAME
    - secretKey: EMAIL_SMTP_PASSWORD
      remoteRef:
        key: {{ .Values.global.secretPrefix }}/{{ .Values.externalSecrets.emailBundle }}
        property: EMAIL_SMTP_PASSWORD
```

Add `emailBundle: email` wherever the sibling `dbBundle`/`storageBundle` values are defined (check each chart's `values.yaml` `externalSecrets:` block AND the umbrella `infrastructure/helm/values.yaml` — mirror the existing pattern exactly).

- [ ] **Step 4: Populate script cleanup**

In `scripts/populate-parameter-store.sh` remove `EMAIL_SMTP_PASSWORD EMAIL_SMTP_USERNAME` from the `keys=(...)` array (they're Terraform-owned now) and update the header comment's examples accordingly. Update the note in the array's inline comment to mention the email bundle is Terraform-generated like db/app-storage.

- [ ] **Step 5: Validate**

Run: `cd infrastructure/terraform && terraform fmt -check && terraform init -backend=false && terraform validate`
Expected: clean.

Run: `helm template infrastructure/helm 2>/dev/null | grep -A3 EMAIL_SMTP` (or `helm template infrastructure/helm/charts/app`)
Expected: rendered ExternalSecret contains the two new data entries; configmap shows the SES endpoint.

- [ ] **Step 6: README + manual runbook**

In `README.md` replace the "Email client" bullet with "Email via AWS SES (SMTP)". Add to the deployment notes section:

```markdown
#### SES cutover runbook

1. `terraform apply` — creates the SES identity, SMTP user, and `/…/email` SSM parameter.
2. Add DNS records at the DNS host: TXT `_amazonses.cpcwood.com` = `ses_domain_verification_token` output; three DKIM CNAMEs from `ses_dkim_tokens` (`<token>._domainkey.cpcwood.com` → `<token>.dkim.amazonses.com`).
3. Request SES production access in the AWS console (new accounts start sandboxed — sandbox delivers only to verified addresses).
4. Deploy the Helm change; send a test contact message and a password-reset email.
```

- [ ] **Step 7: Commit**

```bash
git add infrastructure scripts README.md
git commit -m "terraform: ses smtp identity and credentials, helm points smtp at ses"
```

---

## Self-Review Notes

- Spec coverage: back buttons (T1), placeholders (T1+T7), buttons (T2), highlight links (T3), dark mode (T4), image scroll load (T5), analytics dashboard humans-only (T6 — bot tracking deliberately NOT added per decision), contact messages in admin (T7), TOTP replacing Twilio incl. env/infra cleanup (T8), SES (T9). All eight user requests + dark mode addition covered.
- Type consistency: `link_url` (serializer) ↔ `linkAttribute` value `'link_url'` (T5); `AnalyticsService.metrics(period)` hash keys match view usage (T6); `TwoFactorAuthService` keeps `auth_code_valid?(session:, auth_code:)` signature so `SessionsController#verify_2fa` is unchanged (T8); `emailBundle: email` ↔ `${local.secret_prefix}/email` (T9).
- Known judgement calls an executor may hit: exact placement of `@use` lines in SCSS (follow file conventions), the admin request-spec login helper name (copy from neighbours), jest async-connect pattern (copy from neighbours), and whether umbrella `values.yaml` or per-chart values holds `externalSecrets.*Bundle` (read before editing).
