# GitHub Copilot Instructions

## Project Context
This is a **Custom Desktop Icons** application built with Electron, React, and TypeScript. The main purpose is desktop icon management with Steam integration.

## Code Formatting Rules - CRITICAL
**ALWAYS follow Prettier formatting standards:**
- Use single quotes for strings
- Semicolons are required
- 2 spaces for indentation (NO TABS)
- 80 character line limit
- Trailing commas in ES5 compatible contexts
- Proper spacing around operators and keywords
- Consistent bracket placement
- Line breaks between logical code blocks

## Tech Stack
- **Frontend**: React 19 + TypeScript 5.8
- **Desktop**: Electron 36
- **Build Tool**: Vite 6
- **Styling**: CSS3 with modern features
- **Package Manager**: npm

## Architecture Guidelines

### File Structure
```
src/
├── components/     # React components
├── hooks/         # Custom React hooks
├── utils/         # Utility functions
├── types/         # TypeScript type definitions
├── styles/        # CSS files
└── assets/        # Static assets

electron/
├── main.ts        # Electron main process
├── preload.ts     # Preload script
└── tsconfig.json  # Electron TypeScript config
```

### Coding Standards

#### TypeScript
- Use strict typing, avoid `any`
- Prefer interfaces over types for object shapes
- Use path aliases: `@/components`, `@/utils`, etc.
- Follow React functional component patterns with hooks

#### React
- Use functional components with hooks
- Prefer composition over inheritance
- Use React.memo for performance optimization
- Follow the single responsibility principle

#### Electron
- Keep main process lightweight
- Use IPC for communication between processes
- Implement proper security practices
- Handle window lifecycle properly

### Code Style

#### General Formatting Rules
- Use single quotes for strings
- Semicolons required
- 2 spaces indentation (no tabs)
- 80 character line limit
- Trailing commas in multiline objects/arrays
- Always use proper indentation and spacing
- Maintain consistent formatting across all files

#### Line Breaks and Spacing
- Add blank lines between logical code blocks
- Use consistent spacing around operators and keywords
- Proper spacing in object literals and arrays
- Maintain consistent indentation levels

#### Comments and Documentation
- Use JSDoc for function and class documentation
- Inline comments should explain "why", not "what"
- Keep comments up-to-date with code changes
- Use proper formatting for multi-line comments

#### File Organization
- Group imports logically (external libraries first, then internal modules)
- Organize code sections with proper spacing
- Export statements at the end of files
- Consistent file naming conventions

#### JSON and Configuration Files
- Use proper indentation (2 spaces)
- Maintain consistent comma usage
- Proper spacing around colons and brackets
- No trailing commas in JSON files

#### Example of Proper Formatting
```typescript
// Good: Proper spacing and indentation
interface UserProps {
  id: number;
  name: string;
  email?: string;
}

export const UserComponent: React.FC<UserProps> = ({ id, name, email }) => {
  const [loading, setLoading] = useState<boolean>(false);
  
  const handleClick = useCallback(() => {
    setLoading(true);
    // Handle user interaction
  }, []);
  
  return (
    <div className="user-component">
      <h1>{name}</h1>
      {email && <p>{email}</p>}
    </div>
  );
};
```

### Error Handling
- Use try-catch blocks for async operations
- Provide meaningful error messages
- Log errors appropriately
- Handle edge cases gracefully

### Performance
- Lazy load components when possible
- Optimize re-renders with React.memo and useMemo
- Use proper key props in lists
- Minimize main process workload

### Security
- Validate all IPC messages
- Sanitize external inputs
- Use contextIsolation in preload scripts
- Follow Electron security best practices

## Steam Integration Specifics
- Handle Steam API errors gracefully
- Cache Steam data appropriately
- Respect Steam rate limits
- Provide offline fallbacks

## Desktop Integration
- Support multiple monitor setups
- Handle system theme changes
- Respect system preferences
- Provide proper notifications

## Testing Guidelines
- Write unit tests for utility functions
- Test React components with React Testing Library
- Mock Electron APIs in tests
- Test IPC communication

## Common Patterns to Follow

### Component Structure
```typescript
interface ComponentProps {
  // Define props with proper types
}

export const Component: React.FC<ComponentProps> = ({ ...props }) => {
  // Hooks at the top
  // Event handlers
  // Render logic
}
```

### Error Boundaries
```typescript
class ErrorBoundary extends React.Component {
  // Implement proper error boundaries for Electron app
}
```

### IPC Communication
```typescript
// Main process
ipcMain.handle('channel-name', async (event, data) => {
  // Handle IPC calls
})

// Renderer process
const result = await window.electronAPI.invoke('channel-name', data)
```

## When Suggesting Code:

### Essential Requirements
1. Always consider the Electron environment
2. Use the established path aliases
3. Follow the TypeScript strict mode
4. Consider cross-platform compatibility
5. Implement proper error handling
6. Use modern React patterns (hooks, functional components)
7. Keep security in mind for desktop applications

### Formatting Requirements
8. **ALWAYS follow proper formatting rules**:
   - Use 2 spaces for indentation
   - Add proper line breaks and spacing
   - Maintain consistent bracket and parentheses placement
   - Use single quotes for strings
   - Include semicolons
   - Respect 80 character line limit
   - **NEVER break Prettier formatting rules**

9. **Code Structure**:
   - Group related code with blank lines
   - Organize imports properly
   - Use consistent naming conventions
   - Add proper TypeScript types
   - Follow Prettier configuration exactly

10. **Quality Checks**:
    - Ensure code is properly formatted before suggesting
    - Check for consistent indentation
    - Verify proper spacing around operators
    - Maintain alignment in object literals and arrays
    - Run Prettier formatting mentally before output

## Code Generation Rules
- **NEVER generate code that violates Prettier rules**
- **ALWAYS use proper TypeScript types**
- **ALWAYS follow the established project patterns**
- **ALWAYS maintain consistent formatting**
