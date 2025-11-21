import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    environment: 'jsdom',
    setupFiles: ['./vitest.setup.ts'],
    globals: true,
    css: false,
    include: ['**/*.test.{ts,tsx}']
  },
  resolve: {
    alias: {
      '@': new URL('./', import.meta.url).pathname,
    },
  },
});
