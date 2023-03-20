# Some notes about this cities-list app by the developer

## users

admin/admin - will be able to edit the name and image of the cities
user/password - will only be able to browse/search the list (but not edit)

## other notes

The session lasts for 60 minutes (as configured in the BE) so if some browsing/searching/editing is tried after that the user will be "logged out" in FE as well and directed to login page

Search bar works so that a new request is not done before 1 second has passed since the last keystroke (to avoid a lot of unnecessary requests)

## Recommended IDE Setup

[VSCode](https://code.visualstudio.com/) + [Volar](https://marketplace.visualstudio.com/items?itemName=Vue.volar) (and disable Vetur) + [TypeScript Vue Plugin (Volar)](https://marketplace.visualstudio.com/items?itemName=Vue.vscode-typescript-vue-plugin).

## Customize configuration

See [Vite Configuration Reference](https://vitejs.dev/config/).

## Project Setup

```sh
npm install
```

### Compile and Hot-Reload for Development

```sh
npm run dev
```

### Compile and Minify for Production

```sh
npm run build
```

### Lint with [ESLint](https://eslint.org/)

```sh
npm run lint
```
