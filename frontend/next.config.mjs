/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: { typedRoutes: true },
  webpack: (config) => {
    // Stable file watching across WSL/mac/Linux
    config.watchOptions = { poll: 800, aggregateTimeout: 300 };
    return config;
  },
};
export default nextConfig;
