import { createClient } from '@supabase/supabase-js';

const supabaseUrl =
  import.meta.env.VITE_SUPABASE_URL || 'https://ikdcqxgecjzgjntejizu.supabase.co';
const supabaseAnonKey =
  import.meta.env.VITE_SUPABASE_ANON_KEY ||
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlrZGNxeGdlY2p6Z2pudGVqaXp1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg4NjUyOTcsImV4cCI6MjA5NDQ0MTI5N30.9AOmDYBhvO0rPJ5Uq5AFXjRvvv4xfQP0xdyQCn3rKHs';

export const supabase = createClient(supabaseUrl, supabaseAnonKey);
