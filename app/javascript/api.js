import { Capacitor } from '@capacitor/core';

// Set Heroku URL for native mobile apps, or relative paths for web desktop
const HEROKU_API_URL = 'https://notebook-metropolis-9fc12d24fe20.herokuapp.com/';
export const API_BASE_URL = Capacitor.isNativePlatform() ? HEROKU_API_URL : '';

export async function apiFetch(endpoint, options = {}) {
  const defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  const response = await fetch(`${API_BASE_URL}${endpoint}`, {
    ...options,
    headers: {
      ...defaultHeaders,
      ...options.headers,
    },
    credentials: 'omit',
  });

  return response;
}
